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
    var meeAgent = MeeAgentStore()
    
    func onNext (_ coreData: RpAuthResponseWrapper, _ url: String) {
        
        if var urlComponents = URLComponents(string: url) {
            urlComponents.queryItems = [URLQueryItem(name: "mee_auth_token", value: coreData.openidResponse.idToken)]
            if let url = urlComponents.url {
                print("url:", url)
                hadConnectionsBefore = true
                state.isReturningUser = true
                if data.consent.isCrossDeviceFlow {
                    print("cross device flow")
                    Task.init {
                        do {
                            try await webService.passConsentOverRelay(data: url.absoluteString)
                            toastState.toast = ToastMessage(type: .success, title: "Success", message: "Connection has been set up! Check the device you started with.")
                            navigationState.currentPage = nil
                        } catch {
                            toastState.toast = ToastMessage(type: .error, title: "Fail", message: "Connection failed. Please try again.")
                            navigationState.currentPage = nil
                        }
                    }
                } else {
                   openURL(url)
                    navigationState.currentPage = nil
                }
            }
        }
    }
    
    func authorizeRequest (_ data: ConsentRequest) {
        let request = state.clearConsentsListFromDisabledOptionals(data)
        let response = meeAgent.authorize(id: data.clientId, item: request)
        if let response {
            onNext(response, data.redirectUri)
        } else {
            toastState.toast = ToastMessage(type: .error, title: "Fail", message: "Connection failed. Please try again.")
        }
    }
    
    func recoverRequest (id: String, url: String, data: ConsentRequest) {
        guard let contextData = meeAgent.getItemById(id: id)
        else {
            return
        }
        let request = ConsentRequest(from: contextData, clientId: data.clientId, nonce: data.nonce, redirectUri: data.redirectUri, isCrossDevice: data.isCrossDeviceFlow, clientMetadata: data.clientMetadata)
        let response = meeAgent.authorize(id: id, item: request)
        if let response {
            onNext(response, url)
        } else {
            toastState.toast = ToastMessage(type: .error, title: "Fail", message: "Connection failed. Please try again.")
        }
    }
    
    var body: some View {
        ZStack {
            if !isLocked {
                if let isReturningUser = state.isReturningUser {
                    if isReturningUser {
                        ConsentPageExisting() {id, url in
                            recoverRequest(id: id, url: url, data: data.consent)
                        }
                    }
                    else {
                        ConsentPageNew(){d in
                            authorizeRequest(d)
                        }
                    }
                }
            }
            
        }
        .onAppear{
            let isReturningUser = meeAgent.getItemById(id: data.consent.id) != nil
            state.isReturningUser = isReturningUser
        }
        .onTapGesture {
            keyboardEndEditing()
        }
    }
}

