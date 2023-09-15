//
//  ContentView.swift
//  Shared
//
//  Created by alex slobodeniuk on 15.02.2022.
//

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

let privoMockUrl = "https://auth.mee.foundation/authorize?scope=openid&request=eyJhbGciOiJFUzI1NiIsImp3ayI6eyJjcnYiOiJQLTI1NiIsImt0eSI6IkVDIiwieCI6IjRMeUtJdkJLTEhnSzZla0ZEOEFOLVNrVTUzdDBLQ09zdzFNZkMtMXBab1kiLCJ5Ijoid01HSGRVU21YdTlxM3lmdHN0akJqSEpnMlo2NkVONFcyR2Vyd1FDazdnNCJ9fQ.eyJjbGllbnRfbWV0YWRhdGEiOnsiY2xpZW50X25hbWUiOiJQcml2byIsImxvZ29fdXJpIjoiaHR0cHM6Ly93d3cucHJpdm8uY29tL2h1YmZzL2Zhdmljb24uaWNvIiwiZGlzcGxheV91cmwiOiJwcml2by5jb20iLCJjb250YWN0cyI6W10sImFwcGxpY2F0aW9uX3R5cGUiOiJ3ZWIiLCJqd2tzIjpbeyJlIjoiQVFBQiIsImt0eSI6IlJTQSIsIm4iOiIwRXUzbEpJcVh0bXp5RVV1endid05DSVlhaVZZTERtdWhQdzVhTEJNZEI1S0xabmRzWlJuTms3QUtiMHRldlgzNWFvVHVWcThteEdlbjJhdzhXdW15cUREV1lIU251di1IUWdMMVgwNHFObHo0QzMtaFlGcE9RUDBpMm5HYjB1NUVaYnR5Ym1oWDh1LUxsQU1SMTN3VXVYeUIyMERSV0JiZnp1MVktTzR1RGJOZExoX3oxdjBLZXcxb0oyS3pHcHlVbGd3b0NmZlVMa1JEdGprN2lDaXdlZUpzZ1d6ek01RmlkUWlyeUpJcUhfZGU4cjE3d29GSVFOOG13aUdVYjRWTjNTYklueklldk5WUnZNdVNuOFdoc0t0M3lZY3ZncDJGcnBIaUl6eFBtSDNNQWV0ckJSV2VGWFZ3TnpQX2gybDVOT3NSbnlOYklVa2M2d3NiTWk3enciLCJhbGciOiJSU0EtT0FFUCIsImtleV9vcHMiOlsiZW5jcnlwdCIsIndyYXBLZXkiXX1dfSwicmVkaXJlY3RfdXJpIjoiaHR0cHM6Ly9wcml2by5jb20iLCJjbGFpbXMiOnsiaWRfdG9rZW4iOnsiYWdlX3Byb3RlY3QiOnsiYXR0cmlidXRlX3R5cGUiOiJodHRwczovL3NjaGVtYS5vcmcvbmFtZSIsIm5hbWUiOiJBZ2UgUHJvdGVjdCIsInR5cCI6ImFnZVByb3RlY3QiLCJlc3NlbnRpYWwiOnRydWUsInJldGVudGlvbl9kdXJhdGlvbiI6IndoaWxlX3VzaW5nX2FwcCIsImJ1c2luZXNzX3B1cnBvc2UiOiIiLCJpc19zZW5zaXRpdmUiOnRydWV9fX0sImNsaWVudF9pZCI6Imh0dHBzOi8vcHJpdm8uY29tIiwic2NvcGUiOiJvcGVuaWQiLCJyZXNwb25zZV90eXBlIjoiaWRfdG9rZW4iLCJub25jZSI6IjA4ZTIyNDBhMmU5ZDRmZmI3M2YwMWVmYjI4NDA5NzkyYWQyNGY2NzhhMTRlY2U3MTU4YzRjOGNkMGNhMDY1N2YiLCJpYXQiOjE2OTE2NzExNTYsImF1ZCI6Imh0dHBzOi8vcHJpdm8uY29tIn0.XtACXSI-Jyo1TwM2ctzlhV5Quz5jKFTT_PjvaoY12882eN2r1jfCPC-YTM1g4LyISMLEtXPCphB4ejPU6-m0Rw"

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
    @Environment(\.openURL) var openURL
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
        if (url.scheme == "meeappdemo") {
            hadConnectionsBefore = true
            guard let host = url.host else {
                return
            }
            if (host == "create") {
                
                Task {
                    let result = await core.authAuthRequestFromUrl(url: privoMockUrl, isCrossDevice: false ,sdkVersion: defaultSdkVersion)
                    guard let result else {
                        return
                    }
                    await core.authorize(id: result.id, item: ConsentRequest(from: Context(from: SiopConsentUniffi(id: result.id, otherPartyConnectionId: result.id, createdAt: String(Date().currentTimeMillis()), attributes: ["age_protect" : OidcClaimParams(essential: true, attributeType: "https://schema.org/name", name: "Age Protect", typ: "ageProtect", retentionDuration: .whileUsingApp, businessPurpose: "", isSensitive: true, value: #"{"jurisdiction":"Jurisdiction: MA, US","age":"Age: 15","dateOfBirth":"Birthdate: 30.03.2008"}"#)])), consentRequest: result))
                    await MainActor.run {
                        toastState.toast = ToastMessage(type: .success, title: "Privo Age Protect", message: "Connection created")
                    }
                    
                }
            } else if (host == "confirm" || host == "confirmReddit") {
                let isCrossDevice = url.path.count > 0
                Task {
                    let allConnections = await core.getAllItems()
                    
                    if (allConnections.contains(where: { connection in
                        return connection.name == "Privo"
                    })) == false {
                        return
                    }
                    
                    print("url.path: ", url.path)
                    
                    let consent = await core.authAuthRequestFromUrl(url: isCrossDevice ? url.path : privoMockUrl, isCrossDevice: isCrossDevice ,sdkVersion: defaultSdkVersion)
                    
                    guard var consent else {
                        return
                    }
                    if (host == "confirm") {
                        consent.clientMetadata.displayUrl = "https://oldeyorktimes.com/#/?ageProtect=hjkiuasgdjhagsdjhmagsdjhvasduoyagsduyjagwwd86ag687dsazdc"
                    } else if (host == "confirmReddit") {
                        consent.clientMetadata.displayUrl = "https://mee.foundation/meeddit/?ageProtect=hjkiuasgdjhagsdjhmagsdjhvasduoyagsduyjagwwd86ag687dsazdc"
                    }
                    print("consent: ", consent)
                    await MainActor.run {
                        
                        data.consent = consent
                        if launchedBefore {
                            navigationState.currentPage = .consent
                        }
                    }
                    
                }
                
                
            }
            
        }
        if (url.scheme == "com.googleusercontent.apps.1043231896197-v3uodk6t5u0i7o5al7h901m9s2t2culp") {
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


