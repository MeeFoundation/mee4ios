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
                    case "consent":
                        do {
                            guard let partnerDataJson = decodeString(components[2]) else {
                                return
                            }
                            let partnerData = try JSONDecoder().decode(ConsentConfiguration.self, from: partnerDataJson)
                            print("partnerData", partnerData)
                            var entries: [ConsentEntryModel] = []
                            partnerData.claim?.forEach{ entry in
                                let convertedEntry = ConsentEntryModel(
                                    name: entry.key,
                                    type: entry.value.field_type, value: nil,
                                    providedBy: nil,
                                    isRequired: entry.value.essential
                                )
                                entries.append(convertedEntry)
                            }
                            guard let client_id = partnerData.client_id,
                                  let name = partnerData.client?.name,
                                  let acceptUrl = partnerData.client?.acceptUrl,
                                  let rejectUrl = partnerData.client?.rejectUrl,
                                  let displayUrl = partnerData.client?.displayUrl,
                                  let logoUrl = partnerData.client?.logoUrl
                            else {
                                return
                            }
                            data.consent = ConsentModel(
                                client_id: client_id,
                                name: name,
                                acceptUrl: acceptUrl,
                                rejectUrl: rejectUrl,
                                displayUrl: displayUrl,
                                logoUrl: logoUrl,
                                isMobileApp: partnerData.client?.isMobileApp ?? false,
                                isMeeCertified: partnerData.client?.isMeeCertified ?? false,
                                entries: entries)
                            navigationState.currentPage = NavigationPages.consent
                        } catch {
                            print("Decoding error: \(error)")
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
