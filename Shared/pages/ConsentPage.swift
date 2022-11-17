//
//  ConsentPage.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 16.02.2022.
//

import SwiftUI

struct ConsentPage: View {
    var isLocked: Bool
    @AppStorage("recoveryPassphrase") var recoveryPassphrase: String?
    @EnvironmentObject var data: ConsentState
    @State private var isPresentingAlert: Bool = false
    let keyChainConsents = KeyChainConsents()
    @State var isReturningUser: Bool?
    @Environment(\.openURL) var openURL
    
    private func onNext (_ jwtToken: String,_ url: String) {
        if let url = URL(string: "\(url)/?token=\(jwtToken)") {
            openURL(url)
            isReturningUser = true
        }
        
    }
    var body: some View {
        ZStack {
            if !isLocked {
                if let isReturningUser {
                    if isReturningUser {
                        ConsentPageExisting() {id, url in
                            print(id)
                            guard let data = keyChainConsents.getItemByName(name: id) else {
                                return
                            }
                            print(data)
                            onNext(data, url)
                            
                        }
                    }
                    else {
                        ConsentPageNew(){data, id, url in
                            print(data)
                            keyChainConsents.editItem(name: id, item: data.toBase64())
                            onNext(data.toBase64(), url)
                        }
                    }
                }
            }
            
        }
        .onAppear{
            isReturningUser = keyChainConsents.getItemByName(name: data.consent.id) != nil
        }
        .alert(isPresented: $isPresentingAlert) {
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

