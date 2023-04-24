//
//  ContentView.swift
//  Shared
//
//  Created by alex slobodeniuk on 15.02.2022.
//

import SwiftUI
import AuthenticationServices

enum NavigationPages: Hashable {
    case consent, login, tutorial, firstRun, connection, mainPage
}

struct ContentView: View {
    @AppStorage("launchedBefore") var launchedBefore: Bool = false
    @EnvironmentObject var data: ConsentState
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject private var navigationState: NavigationState
    @EnvironmentObject private var toastState: ToastState
    @Environment(\.scenePhase) var scenePhase
    
    @State var appWasMinimized: Bool = true
    
    func setUnlocked(result: Bool) {
        print("unlocked: ", result)
        appWasMinimized = !result
    }
        
    func tryAuthenticate() {
        
        if launchedBefore  {
            requestLocalAuthentication(setUnlocked)
        }
    }
    
    func processUrl(url: URL) {
//        print(url)
        if (url.host == "mee.foundation" || url.host == "www.mee.foundation" || url.host == "www-dev.mee.foundation" || url.host == "auth-dev.mee.foundation" || url.host == "auth.mee.foundation") {
            
            let sanitizedUrl = url.absoluteString.replacingOccurrences(of: "/#/", with: "/")
            if let initializedUrl = URL.init(string: sanitizedUrl) {
                let components = initializedUrl.pathComponents
                if (components.count > 1) {
                    switch (components[1]) {
                    case "consent", "cdconsent":
                        do {
                            let partnerDataString = components[2]
                            let partnerData = try rpAuthRequestFromJwt(jwtString: partnerDataString)
                            guard let consent = ConsentRequest(from: partnerData, isCrossDevice: components[1] == "cdconsent") else {
                                return
                            }
                            print("new consent request: ", consent)
                            data.consent = consent
                            if launchedBefore {
                                navigationState.currentPage = .consent
                            }
                            
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
        ZStack {
            Group {
                NavigationPage(isLocked: appWasMinimized)
            }
        }
        .overlay{
            LoginPage()
                .opacity((launchedBefore && appWasMinimized) ? 1 : 0)
        }
        .font(Font.custom("PublicSans-Regular", size: 16))
        .onAppear{
            tryAuthenticate()
        }
        .onChange(of: launchedBefore) {_ in
                tryAuthenticate()
        }
        .onChange(of: scenePhase) { newPhase in
            switch (newPhase) {
            case .background:
                print("background")
                if (navigationState.currentPage == .consent) {
                    navigationState.currentPage = .mainPage
                }
                appWasMinimized = true
            
            case .active:
                print("active")
                if appWasMinimized {
                    tryAuthenticate()
                }
            case .inactive:
                print("inactive")
            @unknown default:
                break;
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


