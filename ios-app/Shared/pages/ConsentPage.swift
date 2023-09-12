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
    @EnvironmentObject var toastState: ToastState
    @Environment(\.openURL) var openURL
    @AppStorage("recoveryPassphrase") var recoveryPassphrase: String?
    @AppStorage("hadConnectionsBefore") var hadConnectionsBefore: Bool = false
    var webService = WebService()
    var core = MeeAgentStore.shared
    
    func onNext (_ coreData: RpAuthResponseWrapper, _ url: String, _ overrideUrl: String?) {
        
        if let overrideUrl {
            if let overrideUrlInitialized = URL(string: overrideUrl) {
                print("String(url.dropFirst()): ", String(url.dropFirst()))
                if data.consent.isCrossDeviceFlow {
                    hadConnectionsBefore = true
                    Task.init {
                        do {
                            try await webService.passConsentOverRelay(id: data.consent.nonce ,data: coreData.openidResponse.idToken)
                            await MainActor.run {
                                toastState.toast = ToastMessage(type: .success, title: "Success", message: "The connection has been set up! Check the device you started with.")
                                navigationState.currentPage = .mainPage
                            }
                            
                        } catch {
                            await MainActor.run {
                                toastState.toast = ToastMessage(type: .error, title: "Fail", message: "The connection failed. Please try again.")
                                navigationState.currentPage = .mainPage
                            }
                            
                        }
                    }
                } else {
                    openURL(overrideUrlInitialized)
                }
                
                
                return
            }
            
        }
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
                            try await webService.passConsentOverRelay(id: data.consent.nonce ,data: coreData.openidResponse.idToken)
                            await MainActor.run {
                                toastState.toast = ToastMessage(type: .success, title: "Success", message: "The connection has been set up! Check the device you started with.")
                                navigationState.currentPage = .mainPage
                            }
                            
                        } catch {
                            await MainActor.run {
                                toastState.toast = ToastMessage(type: .error, title: "Fail", message: "The connection failed. Please try again.")
                                navigationState.currentPage = .mainPage
                            }
                            
                        }
                    }
                } else {
                    openURL(url)
                    navigationState.currentPage = .mainPage
                }
            }
        }
    }
    
    func authorizeRequest (_ data: ConsentRequest) async {
        let request = state.clearConsentsListFromDisabledOptionals(data)
        let response = await core.authorize(id: data.clientId, item: request)
        print("response: ", response)
        await MainActor.run {
            if let response {
                onNext(response, data.redirectUri, nil)
            } else {
                toastState.toast = ToastMessage(type: .error, title: "Fail", message: "Connection failed. Please try again.")
            }
        }
        
    }
    
    func recoverRequest (id: String, url: String, data: ConsentRequest) async {
        guard let contextData = await core.getLastConnectionConsentById(id: id)
        else {
            return
        }
        var updatedUrl: String? = nil
        let request = ConsentRequest(from: contextData, consentRequest: data)
        print("request.clientMetadata.name: ", request.clientMetadata.name)
        if (request.clientMetadata.name == "Privo") {
            updatedUrl = "https://oldeyorktimes.com/#/?ageProtect=hjkiuasgdjhagsdjhmagsdjhvasduoyagsduyjagwwd86ag687dsazdc"
        }
        let response = await core.authorize(id: id, item: request)
        await MainActor.run {
            if let response {
                onNext(response, url, updatedUrl)
            } else {
                toastState.toast = ToastMessage(type: .error, title: "Fail", message: "Connection failed. Please try again.")
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
                let isReturningUser = await core.getConnectionById(id: data.consent.id) != nil
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

