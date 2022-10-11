//
//  ContentView.swift
//  Shared
//
//  Created by alex slobodeniuk on 15.02.2022.
//

import SwiftUI
import AuthenticationServices

enum NavigationPages: Hashable {
  case home, consent, signUp, login, passwordManager, mainViewPage
}

struct ContentView: View {
    @AppStorage("launchedBefore") var launchedBefore: Bool = false
    @EnvironmentObject var data: ConsentState
    
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
            if (launchedBefore) {
                requestLocalAuthentication(setUnlocked)
            }
        } else {
            isAuthenticated = true
        }
    }
    
    func processUrl(url: URL) {
        if (url.host == "getmee.org" || url.host == "www.getmee.org") {
            let sanitizedUrl = url.absoluteString.replacingOccurrences(of: "/#/", with: "/")
            let components = URL.init(string: sanitizedUrl)?.pathComponents ?? []
      
            if (components.count > 1) {
                print("components[1]:", components[1])
                switch (components[1]) {
                case "consent":
                    do {
                        guard let jsonString = components[2].fromBase64() else {
                            return
                        }
                        guard let partnerDataJson = jsonString.data(using: .utf8) else {
                            return
                        }
                        let partnerData: PartnerData = try JSONDecoder().decode(PartnerData.self, from: partnerDataJson)
                        data.consent.id = partnerData.partnerId
                        data.consent.name = partnerData.partnerName
                        data.consent.url = partnerData.partnerUrl
                        data.consent.imageUrl = partnerData.partnerImageUrl
                        data.consent.displayUrl = partnerData.partnerDisplayedUrl
                        print("partnerData", partnerData)
                        navigationState.currentPage = NavigationPages.consent
                    } catch {
                        return
                    }
                default: break
            
                }
            }
            
        }
    }
    
    var body: some View {
        ZStack {
            Group {
                if !launchedBefore  {
                    FirstRunPage()
                }  else {
                    if isAuthenticated && !appWasMinimized {
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
//                            if (!launchedBefore && UIPasteboard.general.hasStrings) {
//                                let clipboard = UIPasteboard.general.string
//                                let url = URL.init(string: clipboard ?? "")
//                                if (url != nil) {
//                                    UIPasteboard.general.string = nil
//                                    processUrl(url: url!)
//                                }
//                            }
                            
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
                        }

                        NavigationLink(
                            destination: MainViewPage()
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                            ,tag: NavigationPages.mainViewPage
                            ,selection: $navigationState.currentPage
                        ){
                        }
                    }
            }
        }
        .navigationViewStyle(.stack)
    }
}
