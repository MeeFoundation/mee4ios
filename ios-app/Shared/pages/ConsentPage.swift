//
//  ConsentPage.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 16.02.2022.
//

import SwiftUI
import Foundation

struct ConsentPage: View {
    var isLocked: Bool
    @EnvironmentObject var data: ConsentState
    @State var state = ConsentPageState()
    @EnvironmentObject var navigationState: NavigationState
    @EnvironmentObject var appState: AppState
    @Environment(\.openURL) var openURL
    @AppStorage("recoveryPassphrase") var recoveryPassphrase: String?
    @AppStorage("hadConnectionsBefore") var hadConnectionsBefore: Bool = false
    var webService = WebService()
    @EnvironmentObject var core: MeeAgentStore
    
    func onFail() async {
        await MainActor.run {
            appState.toast = ToastMessage(type: .error, title: "Fail", message: "The connection failed. Please try again.")
            navigationState.currentPage = .mainPage
        }
    }
    
    func onNext (_ coreData: OidcAuthResponseWrapper, _ url: String) {
        
        if var urlComponents = URLComponents(string: url) {
            urlComponents.queryItems = [URLQueryItem(name: data.consent.sdkVersion == .v1 ? "mee_auth_token" : "id_token", value: coreData.openidResponse.idToken)]
            if let url = urlComponents.url
            {
                print(url)
                hadConnectionsBefore = true
                state.isReturningUser = true
                if data.consent.isCrossDeviceFlow {
                    print("cross device flow")
                    Task.init {
                        do {
                            guard let idToken = coreData.openidResponse.idToken else {
                                await onFail()
                                return
                            }
                            try await webService.passConsentOverRelay(id: data.consent.nonce ,data: idToken)
                            await MainActor.run {
                                appState.toast = ToastMessage(type: .success, title: "Success", message: "The connection has been set up! Check the device you started with.")
                                navigationState.currentPage = .mainPage
                            }
                            
                        } catch {
                            await onFail()
                        }
                    }
                } else {
                    openURL(url)
                    navigationState.currentPage = .mainPage
                }
            }
        }
    }
    
    func authorizeRequest (_ data: MeeConsentRequest) async {
        let request = state.clearConsentsListFromDisabledOptionals(data)
        let response = await core.authorize(id: data.clientId, item: request)
        print("response: ", response)
        await MainActor.run {
            if let response {
                onNext(response, data.redirectUri)
            } else {
                appState.toast = ToastMessage(type: .error, title: "Fail", message: "Connection failed. Please try again.")
            }
        }
        
    }
    
    func recoverRequest (id: String, url: String, data: MeeConsentRequest) async {
        guard let contextData = await core.getLastSiopConsentByConnectionId(id: id.getHostname() ?? id)
        else {
            appState.toast = ToastMessage(type: .error, title: "Fail", message: "Connection not found.")
            navigationState.currentPage = .mainPage
            return
        }
        let request = MeeConsentRequest(from: contextData, consentRequest: data)
        let response = await core.authorize(id: id, item: request)
        await MainActor.run {
            if let response {
                onNext(response, url)
            } else {
                appState.toast = ToastMessage(type: .error, title: "Fail", message: "Connection failed. Please try again.")
            }
        }
        
    }
    
    var body: some View {
        ZStack {
            if !isLocked {
                if let isReturningUser = state.isReturningUser {
                    if isReturningUser {
                        ConsentPageExisting() {id, url in
                            Task.init {
                                await recoverRequest(id: id, url: url, data: data.consent)
                            }
                        }
                    }
                    else {
                        ConsentPageNew(){d in
                            Task.init {
                                await authorizeRequest(d)
                            }
                        }
                    }
                }
            }
            
        }
        .onAppear{
            Task.init {
                let isReturningUser = await core.checkSiopConnectionExists(id: data.consent.id.getHostname() ?? data.consent.id)
                await MainActor.run {
                    state.isReturningUser = isReturningUser
                }
                
            }
        }
        .onTapGesture {
            keyboardEndEditing()
        }
    }
}

