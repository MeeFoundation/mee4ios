//
//  ContentView.swift
//  Shared
//
//  Created by alex slobodeniuk on 15.02.2022.
//

import SwiftUI
import AuthenticationServices

enum NavigationPages: Hashable {
    case consent, mainViewPage, login
}

struct ContentView: View {
    @AppStorage("launchedBefore") var launchedBefore: Bool = false
    @EnvironmentObject var data: ConsentState
    
    @EnvironmentObject private var navigationState: NavigationState
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
        if (url.host == "mee.foundation" || url.host == "www.mee.foundation" || url.host == "www-dev.mee.foundation" || url.host == "auth-dev.mee.foundation") {
            let sanitizedUrl = url.absoluteString.replacingOccurrences(of: "/#/", with: "/")
            if let initializedUrl = URL.init(string: sanitizedUrl) {
                let components = initializedUrl.pathComponents
                
                if (components.count > 1) {
                    switch (components[1]) {
                    case "consent", "cdconcent":
                        do {
                            let partnerDataString = components[2]
                            let partnerData = try rpAuthRequestFromJwt(jwtString: partnerDataString)
                            guard let consent = ConsentRequest(from: partnerData, isCrossDevice: components[1] == "cdconsent") else {
                                return
                            }
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
                if !launchedBefore  {
                    FirstRunPage()
                }  else {
                    NavigationPage(isLocked: appWasMinimized || !isAuthenticated)
                }
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
            print(url)
            processUrl(url: url)
        }
    }
}

struct NavigationPage: View {
    var isLocked: Bool
    @EnvironmentObject private var navigationState: NavigationState
    
    var body: some View {
        ZStack {
            Background()
            VStack {
                NavigationLink(
                    "Consent",
                    destination: ConsentPage(isLocked: isLocked)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                    ,tag: NavigationPages.consent
                    ,selection: $navigationState.currentPage
                )
                
                NavigationLink(
                    "Main",
                    destination: MainViewPage()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                    ,tag: NavigationPages.mainViewPage
                    ,selection: $navigationState.currentPage
                )
                
            }
        }
    }
}
