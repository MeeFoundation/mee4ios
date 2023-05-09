//
//  ConsentsList.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct ConsentsList: View {
    let meeAgent = MeeAgentStore.shared
    var registry = PartnersRegistry.shared
    @EnvironmentObject var navigationState: NavigationState
    
    @State private var state = ConsentsListState()
    @Environment(\.openURL) var openURL
    let data: [Connection]
    
    init() {
        data = meeAgent.getAllItems() ?? []
    }
    
    
    func refreshPartnersList() {
        state.existingPartnersWebApp = data.filter{ context in
            if case let .Siop(value) = context.value {
                return value.clientMetadata.type == .web && meeAgent.getLastConnectionConsentById(id: context.id) != nil
            }
            return false
        }
        state.existingPartnersMobileApp = data.filter{ context in
            if case let .Siop(value) = context.value {
                return value.clientMetadata.type == .mobile && meeAgent.getLastConnectionConsentById(id: context.id) != nil
            }
            return false
        }
        state.otherPartnersWebApp = registry.partners.filter { context in
            return state.existingPartnersWebApp?.firstIndex{$0.id.getHostname() == context.id.getHostname()} == nil
        }

    }
    
    var body: some View {
        
        ZStack {
            if state.showCertifiedOrCompatible != nil {
                VStack {
                    if let certifiedUrl {
                        if let compatibleUrl {
                            WebView(url: state.showCertifiedOrCompatible == .certified ? certifiedUrl : compatibleUrl)
                                .padding(.horizontal, 10)
                        }
                        
                    }
                    
                    SecondaryButton("Close", action: {
                        state.showCertifiedOrCompatible = nil
                    })
                    .padding(.bottom, 10)
                }
            } else {
                ZStack {
                    VStack {
                        ZStack {
                            BasicText(text: "Connections", color: .black ,size: 17, fontName: FontNameManager.PublicSans.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 59)
                        .padding(.bottom, 10)
                        .background(Colors.backgroundAlt1)
                        .shadow(color: Color.black.opacity(0.3), radius: 0, x: 0, y: 0.5)
                        ScrollView {
                            VStack {
                                ForEach([PartnerArray(data: state.existingPartnersWebApp, name: "Sites", editable: true),
                                         PartnerArray(data: state.existingPartnersMobileApp, name: "Mobile Apps", editable: true),
                                         PartnerArray(data: state.otherPartnersWebApp, name: "Sites to connect to", editable: false)
                                        ]) { partnersArray in
                                    if !(partnersArray.data ?? []).isEmpty {HStack {
                                        BasicText(text: partnersArray.name, color: Colors.text, size: 16, fontName: FontNameManager.PublicSans.medium)
                                        Spacer()
                                    }
                                    .padding(.leading, 4)
                                    .padding(.top, 24)
                                    .padding(.bottom, 4)
                                    }
                                    ForEach(partnersArray.data ?? []) { partnerData in
                                        NavigationLink(
                                            destination: PartnerDetails(connection: partnerData),
                                            tag: partnerData.id,
                                            selection: $state.selection
                                        ){}
                                        PartnerEntry(connection: partnerData, hasEntry: partnersArray.editable)
                                            .onTapGesture(perform: {
                                                if partnersArray.editable {
                                                    state.selection = partnerData.id
                                                    
                                                }
                                                else {
                                                    switch (partnerData.value) {
                                                    case .Gapi(_):
                                                        state.showCompatibleWarning = true
                                                    default:
                                                        if let url = URL(string: partnerData.id) {
                                                            openURL(url)
                                                        }
                                                    }
                                                    
                                                }
                                            })
                                            .padding(.top, 8)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            
                        }
                        VStack {
                            Button(action: {
                                state.showCertifiedOrCompatible = .certified
                            }) {
                                HStack {
                                    Image("meeCertifiedLogo").resizable().scaledToFit().frame(width: 20)
                                    BasicText(text:"Mee-certified?", color: Colors.meeBrand, size: 14, underline: true)
                                }
                            }

                        }
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        
                    }
                    .background(Color.white)
                    
                }
                .ignoresSafeArea(.all)
                .background(Color.white)
                .frame(maxWidth: .infinity)
                .overlay {
                    WarningPopup(text: "You will be redirected to your default browser to login to your Google Account and pull your data from it to Mee local storage", iconName: "google") {
                        state.showCompatibleWarning = false
                        if let url = meeAgent.getGoogleIntegrationUrl() {
                            openURL(url)
                        }
                    }
                    .ignoresSafeArea(.all)
                    .opacity(state.showCompatibleWarning ? 1 : 0)
                }
                
                
            }
            
        }
        .onAppear {
            refreshPartnersList()
        }
        .ignoresSafeArea(.all)
        
        
        
    }
}

