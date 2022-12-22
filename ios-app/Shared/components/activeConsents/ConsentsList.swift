//
//  ConsentsList.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct ConsentsList: View {
    let keychain = MeeAgentStore()
    @EnvironmentObject var data: PartnersState
    @State private var state = ConsentsListState()

    func refreshPartnersList(_ firstLaunch: Bool) {
        state.existingPartnersWebApp = data.partners.filter{ partner in
            !partner.isMobileApp && keychain.getItemByName(name: partner.client_id) != nil
        }
        state.existingPartnersMobileApp = data.partners.filter{ partner in
            partner.isMobileApp && keychain.getItemByName(name: partner.client_id) != nil
        }
        if firstLaunch {
            if let existingPartnersWebApp = state.existingPartnersWebApp {
                if let existingPartnersMobileApp = state.existingPartnersMobileApp {
                    if existingPartnersWebApp.isEmpty && existingPartnersMobileApp.isEmpty {
                        state.showWelcome = true
                    } else {
                        state.showWelcome = false
                    }
                }
                
            }
        }
        
        state.otherPartnersWebApp = data.partners.filter{ partner in
            if partner.client_id == "nytcompatible" || (partner.client_id == "nyt" && !(state.existingPartnersWebApp ?? []).isEmpty) {return false}
            return !partner.isMobileApp && keychain.getItemByName(name: partner.client_id) == nil
        }
        state.otherPartnersMobileApp = data.partners.filter{ partner in
            return partner.isMobileApp && keychain.getItemByName(name: partner.client_id) == nil
        }
    }
    
    var body: some View {
    
            ZStack {
                if state.showCertifiedOrCompatible != nil {
                    VStack {
                        if let certifiedUrl {
                            if let compatibleUrl {
                                WebView(request: URLRequest(url: (state.showCertifiedOrCompatible == .certified) ? certifiedUrl : compatibleUrl))
                                    .padding(.horizontal, 10)
                            }
                            
                        }
                        
                        SecondaryButton("Close", action: {
                            state.showCertifiedOrCompatible = nil
                        })
                        .padding(.bottom, 10)
                    }
                } else {
                    
                    if state.showWelcome != nil {
                        if state.showWelcome == false {
                            
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
                                                     PartnerArray(data: state.otherPartnersWebApp, name: "Other Sites You Might Like", editable: false),
                                                     PartnerArray(data: state.otherPartnersMobileApp, name: "Other Mobile Apps You Might Like", editable: false)]) { partnersArray in
                                                if !(partnersArray.data ?? []).isEmpty {HStack {
                                                    BasicText(text: partnersArray.name, color: Colors.text, size: 16, fontName: FontNameManager.PublicSans.medium)
                                                    Spacer()
                                                }
                                                .padding(.leading, 4)
                                                .padding(.top, 24)
                                                .padding(.bottom, 4)
                                                }
                                                ForEach(partnersArray.data ?? []) { partnerData in
                                                    NavigationLink(destination: PartnerDetails(partner: partnerData), tag: partnerData.id, selection: $state.selection){}
                                                    PartnerEntry(partner: partnerData, hasEntry: partnersArray.editable)
                                                        .onTapGesture(perform: {
                                                            if partnersArray.editable {
                                                                state.selection = partnerData.client_id
                                                            } else if !partnerData.isMeeCertified {
                                                                state.showCompatibleWarning = true
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
                                        Button(action: {
                                            state.showCertifiedOrCompatible = .compatible
                                        }) {
                                            HStack {
                                                Image("meeCompatibleLogo").resizable().scaledToFit().frame(width: 20)
                                                BasicText(text:"Mee-compatible?", color: Colors.meeBrand, size: 14, underline: true)
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
                                WarningPopup(text: "Your data will not be protected by HIL and will be treated according to the terms of service and privacy policy of the website.") {
                                    state.showCompatibleWarning = false
                                }
                                .ignoresSafeArea(.all)
                                .opacity(state.showCompatibleWarning ? 1 : 0)
                            }
                            
                        } else {
                            FirstRunPageWelcome() {
                                state.showWelcome = false
                            }
                        }
                    }
                }
                
            }
            .onAppear {
                if state.firstLaunch {
                    refreshPartnersList(true)
                    state.firstLaunch = false
                } else {
                    refreshPartnersList(false)
                }
            }
            .ignoresSafeArea(.all)
            
        
        
    }
}
