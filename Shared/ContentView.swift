//
//  ContentView.swift
//  Shared
//
//  Created by alex slobodeniuk on 15.02.2022.
//

import SwiftUI
import Mee_Credential_Provider
import AuthenticationServices

enum NavigationPages: Hashable {
  case home, consent, signUp, login, passwordManager, emptyApp
}

struct ContentView: View {
    @AppStorage("launchedBefore") var launchedBefore: Bool = false
 
    
    @EnvironmentObject private var navigationState: NavigationState
    @Environment(\.scenePhase) var scenePhase
    init() {
 
    }
    
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
            requestLocalAuthentication(setUnlocked)
        } else {
            isAuthenticated = true
        }
    }
    
    var body: some View {
        ZStack {
            Group {
                if !launchedBefore  {
                    FirstRunPage()
                }  else {
                    if isAuthenticated {
                        NavigationPage().disabled(appWasMinimized)
                    } else {
                        LoginPage()
                    }
                }
            }
        }
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
                                navigationState.currentPage = NavigationPages.emptyApp
                            }

                            appWasMinimized = true
                        }
        }
        .onOpenURL { url in
            print(url)
            if (url.host != nil) {
                switch (url.host) {
                    case "consent":
                    navigationState.currentPage = NavigationPages.consent
                    default: break
                    
                }
            }
        }
    }
}

struct NavigationPage: View {
    @EnvironmentObject private var navigationState: NavigationState
    var body: some View {
        NavigationView {
            ZStack {
                Background()
                    VStack {
                        NavigationLink(
                            destination: ConsentPage()
                            .navigationBarTitle("", displayMode: .inline)
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                            ,tag: NavigationPages.consent
                            ,selection: $navigationState.currentPage
                        ){
                            Text("Consent Page")
                                .font(.largeTitle)
                        }

                        NavigationLink(
                            destination: EmptyAppPage()
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                            ,tag: NavigationPages.emptyApp
                            ,selection: $navigationState.currentPage
                        ){
//                            Text("Tabs")
//                                .font(.largeTitle)
//                                .padding(.top, 10.0)
                        }
//                        Button("Add password to keychain") {
//                            let keychain = KeyChain()
//                            print(keychain.getAllItems())
//                        }
                    }
            }
            
        }
    }
}
