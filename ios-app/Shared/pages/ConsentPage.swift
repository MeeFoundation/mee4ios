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
    let meeAgent = MeeAgentStore()
    @State var state = ConsentPageState()
    @Environment(\.openURL) var openURL
    
    private func onNext (_ data: [ConsentEntryModel], _ url: String) {
        let response = makeMeeResponse(data)
        let encodedResponse = encodeJson(response).toBase64()
        print("encodedResponse", encodedResponse)
        if let url = URL(string: "\(url)/?token=\(encodedResponse)") {
            openURL(url)
            state.isReturningUser = true
        }
        
    }
    var body: some View {
        ZStack {
            if !isLocked {
                if let isReturningUser = state.isReturningUser {
                    if isReturningUser {
                        ConsentPageExisting() {id, url in
                            print(id)
                            do {
                                guard let dataString = meeAgent.getItemByName(name: id) else {
                                    return
                                }
                                print(dataString)
                                guard let data = decodeString(dataString) else {
                                    return
                                }
                                let partnerData = try JSONDecoder().decode([ConsentEntryModel].self, from: data)
                                onNext(partnerData, url)
                            } catch {
                                print(error)
                            }
                            
                        }
                    }
                    else {
                        ConsentPageNew(){data, id, url in
                            print(data)
                            meeAgent.editItem(name: id, item: encodeJson(data).toBase64())
                            onNext(data, url)

                        }
                    }
                }
            }
            
        }
        .onAppear{
            state.isReturningUser = meeAgent.getItemByName(name: data.consent.id) != nil
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

