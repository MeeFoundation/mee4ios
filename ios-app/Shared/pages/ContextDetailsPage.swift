//
//  ConsentDetails.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct ContextDetailsPage: View {
    var connector: MeeConnectorWrapper
    @State var state = PartnerDetailsState()
    @EnvironmentObject var core: MeeAgentStore
    init(connector: MeeConnectorWrapper) {
            self.connector = connector
    }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var navigationState: NavigationState
    
    
    func removeConnector() {
        Task.init {
            await core.removeConnector(connector: connector)
            await MainActor.run {
                self.presentationMode.wrappedValue.dismiss()
            }
            
        }
    }
    
    var body: some View {
        return (
            
            VStack {
                Header(text: "Manage Connection") {
                    self.presentationMode.wrappedValue.dismiss()
                }
                ScrollViewReader { proxy in
                ScrollView {
                    PartnerEntry(connector: connector, hasEntry: false)
                        .border(Colors.meeBrand, width: 2)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 48)
                        .padding(.top, 16)
                    switch (state.consentEntries) {
                    case .SiopClaims(let claims):
                        Expander(title: "Required info shared", isOpen: $state.isRequiredOpen) {
                            ForEach(Binding(get: {claims}, set: { state.consentEntries = .SiopClaims(value: $0)}).filter {$0.wrappedValue.isRequired}) { $entry in
                                VStack {
                                    ConsentEntry(entry: $entry, isReadOnly: true) {
                                        state.durationPopupId = entry.id
                                    }
                                    .id(entry.id)
                                    Divider()
                                        .frame(height: 1)
                                        .background(Colors.gray)
                                }
                                
                                
                            }
                            .padding(.top, 19)
                            .padding(.leading, 3)
                            
                        }
                        .padding(.horizontal, 16)
                        if Binding(get: {claims}, set: { state.consentEntries = .SiopClaims(value: $0)}).firstIndex(where: {!$0.wrappedValue.isRequired && !$0.wrappedValue.isEmpty}) != nil {
                            Expander(title: "Optional info shared", isOpen: $state.isOptionalOpen) {
                                ForEach(Binding(get: {claims}, set: { state.consentEntries = .SiopClaims(value: $0)}).filter {!$0.wrappedValue.isRequired && !$0.wrappedValue.isEmpty}) { $entry in
                                    VStack {
                                        ConsentEntry(entry: $entry, isReadOnly: true) {
                                            state.durationPopupId = entry.id
                                        }
                                        .id(entry.id)
                                        Divider()
                                            .frame(height: 1)
                                            .background(Colors.gray)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                        }
                    case .GapiEntries(let gapiUserInfo):
                        if case let .gapi(gapiEntries) = gapiUserInfo.data {
                            let entries: [(String, String)] = Mirror(reflecting: gapiEntries.userInfo).children
                                .reduce([]){ (acc: [(String, String)] , item) in
                                    var copy = acc
                                    if let value = item.value as? String,
                                       let label = item.label
                                    {
                                        if item.label == "familyName" ||
                                           item.label == "givenName" ||
                                           item.label == "email" {
                                            copy.append((label, value))
                                        }
                                        
                                    }
                                    return copy
                                    
                                }
                            ForEach(entries, id: \.self.0) { entry in
                                ExternalConsentEntry(entry: entry)
                            }
                        }
                        
                        
 
                    default: ZStack{}
                    }
                    
                    Spacer()
                    
                    Button(action: removeConnector){
                        HStack(spacing: 0) {
                            BasicText(text: "Delete Connection", color: Colors.error, size: 17)
                            Spacer()
                            Image("trashIcon").resizable().scaledToFit().frame(height: 17)
                        }
                        .padding(.vertical, 12)
                        .padding(.leading, 16)
                        .padding(.trailing, 19)
                        .background(.white)
                    }
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 64, x: 0, y: 8)
                    .padding(.top, 80)
                    .padding(.bottom, 16)
                    .padding(.horizontal, 16)
                }
            }
                
            }
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                .onAppear{
                    Task.init {
                        if let contextData = await core.getLastConnectionConsentById(id: connector.otherPartyConnectionId) {
                            print(contextData)
                            await MainActor.run {
                                state.consentEntries = .SiopClaims(value: contextData.attributes)
                            }
                        } else if let consentData = await core.getLastExternalConsentById(connectorId: connector.id) {
                            await MainActor.run {
                                state.consentEntries = .GapiEntries(value: consentData)
                            }
                        }
                    }
                }
                .overlay {
                    PopupWrapper(isVisible: state.durationPopupId != nil) {
                        if let durationPopupId = state.durationPopupId {
                            if case let .SiopClaims(value) = state.consentEntries {
                                ConsentDuration(consentEntries: Binding(get: {value}, set: { state.consentEntries = .SiopClaims(value: $0)}), id: durationPopupId){
                                    state.durationPopupId = nil
                                }
                            }
                        }

                    }
                }
        )
    }
}
