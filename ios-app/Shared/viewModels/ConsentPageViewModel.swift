//
//  ConsentPageViewModel.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 17.11.23..
//

import Foundation

extension ConsentPage {
    @MainActor class ConsentPageViewModel: ObservableObject {
        var isPresentingAlert: Bool = false
        var isReturningUser: Bool?
        var appState: AppState?
        var navigationState: NavigationState?
        var data: ConsentState?
        var hadConnectionsBefore: Bool?
        var openURL: ((_ url: URL) -> Void)?
        var core: MeeAgentStore?
        var webService: WebService?
        
        func setup(appState: AppState, navigationState: NavigationState, data: ConsentState, hadConnectionsBefore: Bool, openURL: @escaping (_ url: URL) -> Void, core: MeeAgentStore, webService: WebService) {
            self.appState = appState
            self.navigationState = navigationState
            self.data = data
            self.hadConnectionsBefore = hadConnectionsBefore
            self.openURL = openURL
            self.core = core
            self.webService = webService
            Task.init {
                let isReturningUser = await core.checkSiopConnectionExists(id: data.consent.id)
                await MainActor.run {
                    self.isReturningUser = isReturningUser
                }
                
            }
        }
        
        func clearConsentsListFromDisabledOptionals (_ data: MeeConsentRequest) -> MeeConsentRequest {
            let dataClearedFromDisabledOptionals = data.claims.map { claim in
                var claimCopy = claim
                if !claim.isRequired && !claim.isOn {
                    claimCopy.value = nil
                }
                return claimCopy
            }
            let request = MeeConsentRequest(claims: dataClearedFromDisabledOptionals, clientMetadata: data.clientMetadata, nonce: data.nonce, clientId: data.clientId, redirectUri: data.redirectUri, presentationDefinition: data.presentationDefinition, isCrossDevice: data.isCrossDeviceFlow, sdkVersion: data.sdkVersion)
            return request
        }
        
        
        func onFail() async {
            await MainActor.run {
                appState?.toast = ToastMessage(type: .error, title: "Fail", message: "The connection failed. Please try again.")
                navigationState?.currentPage = .mainPage
            }
        }
        
        func onNext (_ coreData: OidcAuthResponseWrapper, _ url: String) {
            
            if var urlComponents = URLComponents(string: url) {
                urlComponents.queryItems = [URLQueryItem(name: data?.consent.sdkVersion == .v1 ? "mee_auth_token" : "id_token", value: coreData.openidResponse.idToken)]
                if let url = urlComponents.url
                {
                    print(url)
                    hadConnectionsBefore = true
                    isReturningUser = true
                    if let data, data.consent.isCrossDeviceFlow {
                        Task.init {
                            do {
                                guard let idToken = coreData.openidResponse.idToken else {
                                    await onFail()
                                    return
                                }
                                try await webService?.passConsentOverRelay(id: data.consent.nonce ,data: idToken)
                                await MainActor.run {
                                    appState?.toast = ToastMessage(type: .success, title: "Success", message: "The connection has been set up! Check the device you started with.")
                                    navigationState?.currentPage = .mainPage
                                }
                                
                            } catch {
                                await onFail()
                            }
                        }
                    } else {
                        if let openURL { openURL(url) }
                        navigationState?.currentPage = .mainPage
                    }
                }
            }
        }
        
        func authorizeRequest (_ data: MeeConsentRequest) async {
            let request = clearConsentsListFromDisabledOptionals(data)
            let response = await core?.authorize(id: data.clientId, item: request)
            print("response: ", response)
            await MainActor.run {
                if let response {
                    onNext(response, data.redirectUri)
                } else {
                    appState?.toast = ToastMessage(type: .error, title: "Fail", message: "Connection failed. Please try again.")
                }
            }
        }
        
        func recoverRequest (id: String, url: String, data: MeeConsentRequest) async {
            guard let contextData = await core?.getLastSiopConsentByRedirectUri(id: id)
            else {
                appState?.toast = ToastMessage(type: .error, title: "Fail", message: "Connection not found.")
                navigationState?.currentPage = .mainPage
                return
            }
            let request = MeeConsentRequest(from: contextData, consentRequest: data)
            let response = await core?.authorize(id: id, item: request)
            await MainActor.run {
                if let response {
                    onNext(response, url)
                } else {
                    appState?.toast = ToastMessage(type: .error, title: "Fail", message: "Connection failed. Please try again.")
                }
            }
            
        }
    }
}
