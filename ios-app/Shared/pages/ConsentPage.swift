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
    @AppStorage("recoveryPassphrase") var recoveryPassphrase: String?
    @AppStorage("hadConnectionsBefore") var hadConnectionsBefore: Bool = false
    
    @EnvironmentObject var data: ConsentState
    let meeAgent = MeeAgentStore()
    @State var state = ConsentPageState()
    @Environment(\.openURL) var openURL
    
    private func onNext (_ data: RpAuthResponseWrapper, _ url: String) {
        
        if var urlComponents = URLComponents(string: url) {
            urlComponents.queryItems = [URLQueryItem(name: "mee_auth_token", value: data.openidResponse.idToken)]
            if let url = urlComponents.url {
                print("url:", url)
                hadConnectionsBefore = true
                state.isReturningUser = true
                openURL(url)
            }
            
        }
        
    }
    var body: some View {
        ZStack {
            if !isLocked {
                if let isReturningUser = state.isReturningUser {
                    if isReturningUser {
                        ConsentPageExisting() {id, url in
                            guard let contextData = meeAgent.getItemById(id: id)
                            else {
                                return
                            }
                            let request = ConsentRequest(from: contextData, clientId: data.consent.clientId, nonce: data.consent.nonce, redirectUri: data.consent.redirectUri, isCrossDevice: data.consent.isCrossDeviceFlow, clientMetadata: data.consent.clientMetadata)
                            let response = meeAgent.authorize(id: id, item: request)
                            if let response {
                                onNext(response, url)
                            }
                        }
                    }
                    else {
                        ConsentPageNew(){data in
                            let response = meeAgent.authorize(id: data.clientId, item: data)
                            if let response {
                                onNext(response, data.redirectUri)
                            }
                        }
                    }
                }
            }
            
        }
        .onAppear{
            let isReturningUser = meeAgent.getItemById(id: data.consent.id) != nil
            state.isReturningUser = isReturningUser
        }
        .alert(isPresented: $state.isPresentingAlert) {
            Alert(title: Text("Set Up Secret Recovery Phrase"), message: Text("Before you will be logged in, let’s set up your secret recovery phrase"), dismissButton: .default(Text("Set Up Secret Recovery Phrase"), action: {
                // TODO: need to redirect to recovery phrase generator ans pass action url to it, so it can redirect us there after passphrase generation
                recoveryPassphrase = "some recovery passphrase"
            }))
        }
        .onTapGesture {
            keyboardEndEditing()
        }
    }
}

