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
    @AppStorage("hadConnectionsBefore") var hadConnectionsBefore: Bool = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var core = MeeAgentStore.shared
    
    @EnvironmentObject private var navigationState: NavigationState
    @EnvironmentObject private var toastState: ToastState
    @Environment(\.scenePhase) var scenePhase
    @State var isLoading: Bool = false
    
    
    @State var appWasMinimized: Bool = true
    
    func setUnlocked(result: Bool) {
        print("unlocked: ", result)
        appWasMinimized = !result
    }
    
    func tryAuthenticate() {
        requestLocalAuthentication(setUnlocked)
    }
    
    func processUrl(url: URL) {
        print(url)
        if (url.scheme == "com.googleusercontent.apps.211039582599-hmmovsfo59081bt9k19kd3k7927nettq") {
            Task {
                do {
                    try await core.createGoogleConnectionAsync(url: url)
                    await MainActor.run {
                        toastState.toast = ToastMessage(type: .success, title: "Google Account", message: "Connection created")
                        hadConnectionsBefore = true
                    }
                    
                } catch {
                    print("google error: ", error)
                    await MainActor.run {
                        toastState.toast = ToastMessage(type: .error, title: "Google Account", message: "Something went wrong")
                    }
                }
            }
        }
        if (url.host == "mee.foundation" || url.host == "www.mee.foundation" || url.host == "www-dev.mee.foundation" || url.host == "auth-dev.mee.foundation" || url.host == "auth.mee.foundation") {
            isLoading = true
            var isCrossDevice = false
            var sdkVersion = defaultSdkVersion
            var sanitizedUrl = url.absoluteString.replacingOccurrences(of: "/#/", with: "/")
            
            //legacy
            if let parsedUrl = URL(string: sanitizedUrl) {
                let components = parsedUrl.pathComponents
                if (components.count > 2) {
                    if components[1] == "consent" {
                        if let newUrlHost = parsedUrl.host,
                           let scheme = parsedUrl.scheme
                        {
                            let request = components[2]
                            let newUrlFormat = "\(scheme)://\(newUrlHost)/authorize?scope=openid&request=\(request)"
                            sanitizedUrl = newUrlFormat
                            sdkVersion = .v1
                        }
                    }
                    
                }
            }
            //legacy end
            
            if let urlComponents = URLComponents(string: sanitizedUrl)
            {
                if let crossDeviceQuery = urlComponents.queryItems?.first(where: { $0.name == "respondTo" })?.value {
                    if crossDeviceQuery == "proxy" {
                        isCrossDevice = true
                    }
                }
            }
            Task {
                let consent = await core.authAuthRequestFromUrl(url: sanitizedUrl, isCrossDevice: isCrossDevice, sdkVersion: sdkVersion)
                await MainActor.run {
                    guard let consent else {
                        isLoading = false
                        return
                    }
                    data.consent = consent
                    if launchedBefore {
                        navigationState.currentPage = .consent
                    }
                    isLoading = false
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
        .overlay {
            FadedLoading()
                .opacity((isLoading) ? 1 : 0)
        }
        .overlay{
            LoginPage()
                .opacity((launchedBefore && appWasMinimized) ? 1 : 0)
        }
        .font(Font.custom("PublicSans-Regular", size: 16))
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
                if appWasMinimized && launchedBefore {
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


