//
//  NavigationViewModel.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 17.11.23..
//

import Foundation

enum UrlProcessResult {
    case googleUrl(url: URL)
    case siopUrl(url: URL)
    case unknown
}

@MainActor class NavigationViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    
    var appState: AppState?
    var core: MeeAgentStore?
    var hadConnectionsBefore: Bool?
    var data: ConsentState?
    var launchedBefore: Bool?
    var navigationState: NavigationState?
    
    func setup(appState: AppState, core: MeeAgentStore, consentState: ConsentState, launchedBefore: Bool, hadConnectionsBefore: Bool, navigationState: NavigationState) {
        self.appState = appState
        self.core = core
        self.data = consentState
        self.hadConnectionsBefore = hadConnectionsBefore
        self.launchedBefore = launchedBefore
        self.navigationState = navigationState
    }
    
    func toggleMenu(_ isOpen: Bool) {
            appState?.isSlideMenuOpened = isOpen
    }
    
    init() {}
    
    private func processGoogleUrl(url: URL) async {
        do {
            try await core?.createGoogleConnectionAsync(url: url)
            appState?.toast = ToastMessage(type: .success, title: "Google Account", message: "Connection created")
            hadConnectionsBefore = true
        } catch {
            appState?.toast = ToastMessage(type: .error, title: "Google Account", message: "Something went wrong")
        }
    }
    
    private func processSiopUrl(url: URL) async {
        var isCrossDevice = false
        let sdkVersion = defaultSdkVersion
        let sanitizedUrl = url.absoluteString.replacingOccurrences(of: "/#/", with: "/")
        
        if let urlComponents = URLComponents(string: sanitizedUrl)
        {
            if let crossDeviceQuery = urlComponents.queryItems?.first(where: { $0.name == "respondTo" })?.value {
                if crossDeviceQuery == "proxy" {
                    isCrossDevice = true
                }
            }
        }
        
        let consent = await core?.authAuthRequestFromUrl(url: sanitizedUrl, isCrossDevice: isCrossDevice, sdkVersion: sdkVersion)
        guard let consent else {
            appState?.toast = ToastMessage(type: .error, title: "Error", message: "Something went wrong")
            return
        }
        data?.consent = consent
        if let launchedBefore = self.launchedBefore, launchedBefore {
            navigationState?.currentPage = .consent
        }
    }
    
    private func sortUrl(_ url: URL) -> UrlProcessResult  {
        print(url)
        if (url.scheme == "com.googleusercontent.apps.1043231896197-v3uodk6t5u0i7o5al7h901m9s2t2culp") {
            return .googleUrl(url: url)
        }
        if (url.host == "mee.foundation" || url.host == "www.mee.foundation" || url.host == "www-dev.mee.foundation" || url.host == "auth-dev.mee.foundation" || url.host == "auth.mee.foundation") {
            return .siopUrl(url: url)
        }
        return .unknown
    }
    
    func processUrl(url: URL) async {
        isLoading = true
        let sortedUrl = sortUrl(url)
        switch(sortedUrl) {
        case .googleUrl(let url):
            await processGoogleUrl(url: url)
        case .siopUrl(let url):
            await processSiopUrl(url: url)
        case .unknown:
            appState?.toast = ToastMessage(type: .error, title: "Error", message: "Request is not valid")
        }
        isLoading = false
    }
    
    
}
