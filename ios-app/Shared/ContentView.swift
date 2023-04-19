//
//  ContentView.swift
//  Shared
//
//  Created by alex slobodeniuk on 15.02.2022.
//

import SwiftUI
import AuthenticationServices

enum NavigationPages: Hashable {
    case consent, mainViewPage, login, tutorial, firstRun
}

struct ContentView: View {
    @AppStorage("launchedBefore") var launchedBefore: Bool = false
    @EnvironmentObject var data: ConsentState
    
    @EnvironmentObject private var navigationState: NavigationState
    @EnvironmentObject private var toastState: ToastState
    @Environment(\.scenePhase) var scenePhase
    
    private var authenticationEnabled = true
    @State var isAuthenticated: Bool = false
    @State var appWasMinimized: Bool = false
    
    func setAuthenticated (result: Bool) {
        isAuthenticated = result
    }
    
    func tryAuthenticate() {
        
        if launchedBefore  {
            if authenticationEnabled {
                requestLocalAuthentication(setAuthenticated)
            } else {
                isAuthenticated = true
            }
        }
    }
    
    func setUnlocked(result: Bool) {
        appWasMinimized = !result
        isAuthenticated = result
    }
    
    func tryReauthenticate() {
        if authenticationEnabled {
            if (launchedBefore) {
                requestLocalAuthentication(setUnlocked)
            }
        } else {
            isAuthenticated = true
        }
    }
    
    func processUrl(url: URL) {
        print(url)
        if (url.host == "mee.foundation" || url.host == "www.mee.foundation" || url.host == "www-dev.mee.foundation" || url.host == "auth-dev.mee.foundation" || url.host == "auth.mee.foundation") {
            
            let sanitizedUrl = url.absoluteString.replacingOccurrences(of: "/#/", with: "/")
            if let initializedUrl = URL.init(string: sanitizedUrl) {
                let components = initializedUrl.pathComponents
                print("components: ", components)
                if (components.count > 1) {
                    switch (components[1]) {
                    case "consent", "cdconsent":
                        do {
                            print("try: ", components[1])
                            let partnerDataString = components[2]
                            let partnerData = try rpAuthRequestFromJwt(jwtString: partnerDataString)
                            guard let consent = ConsentRequest(from: partnerData, isCrossDevice: components[1] == "cdconsent") else {
                                return
                            }
                            print("success: ", consent)
                            data.consent = consent
                            navigationState.currentPage = NavigationPages.consent
                        } catch {
                            return
                        }
                    default: break
                        
                    }
                }
            }
            
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                NavigationPage(isLocked: appWasMinimized || !isAuthenticated)
            }
        }
        .overlay{
            LoginPage()
                .opacity(launchedBefore && (appWasMinimized || !isAuthenticated) ? 1 : 0)
        }
        .navigationViewStyle(.stack)
        .font(Font.custom("PublicSans-Regular", size: 16))
        .onAppear(perform: tryAuthenticate)
        .onChange(of: launchedBefore) {launchedBeforeNewState in
            tryAuthenticate()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("active")
                if appWasMinimized {tryReauthenticate()}
            } else if newPhase == .inactive {
                print("inactive")
            } else if newPhase == .background {
                print("background")
                if (navigationState.currentPage == NavigationPages.consent) {
                    navigationState.currentPage = NavigationPages.mainViewPage
                }
                
                appWasMinimized = true
            }
        }
        .onOpenURL { url in
            processUrl(url: url)
        }
        .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
                guard let url = userActivity.webpageURL else {
                        return
                }
                processUrl(url: url)
        }
        .toastView(toast: $toastState.toast)
    }
}


