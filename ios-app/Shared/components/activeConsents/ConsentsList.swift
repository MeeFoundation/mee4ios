//
//  ConsentsList.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct ConsentsList: View {
    let meeAgent = MeeAgentStore()
    var registry = PartnersRegistry.shared
    @AppStorage("hadConnectionsBefore") var hadConnectionsBefore: Bool = false
    
    @State private var state = ConsentsListState()
    @Environment(\.openURL) var openURL
    let data: [Context]
    
    init() {
       data = meeAgent.getAllItems() ?? []
        print("data: ", data)
    }
    
    
    func refreshPartnersList(_ firstLaunch: Bool) {
        state.existingPartnersWebApp = data.filter{ consent in
            consent.clientMetadata.type == .web && meeAgent.getItemById(id: consent.id) != nil
        }
        state.existingPartnersMobileApp = data.filter{ consent in
            consent.clientMetadata.type == .mobile && meeAgent.getItemById(id: consent.id) != nil
        }
        state.otherPartnersWebApp = registry.partners.filter { consent in
            state.existingPartnersWebApp?.firstIndex{$0.id == consent.id} == nil
        }
        if firstLaunch {
            if let existingPartnersWebApp = state.existingPartnersWebApp {
                if let existingPartnersMobileApp = state.existingPartnersMobileApp {
                    if existingPartnersWebApp.isEmpty && existingPartnersMobileApp.isEmpty && !hadConnectionsBefore {
                        state.showWelcome = .FIRST
                    } else {
                        state.showWelcome = .NONE
                    }
                }
                
            }
        }
        
//        state.otherPartnersWebApp = data.filter{ consent in
//            return consent.clientMetadata.type == .web && meeAgent.getItemById(id: partner.did) == nil
//        }
//        state.otherPartnersMobileApp = data.filter{ consent in
//            return consent.clientMetadata.type == .mobile && meeAgent.getItemById(id: partner.did) == nil
//        }
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

                if state.showWelcome != nil {
                    if state.showWelcome == .NONE {

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
                                                 PartnerArray(data: state.otherPartnersWebApp, name: "Other Sites You Might Like", editable: false)
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
                                                NavigationLink(destination: PartnerDetails(request: ConsentRequest(from: partnerData)), tag: partnerData.id, selection: $state.selection){}
                                                PartnerEntry(request: ConsentRequest(from: partnerData), hasEntry: partnersArray.editable)
                                                    .onTapGesture(perform: {
                                                        if partnersArray.editable {
                                                            state.selection = partnerData.id
                                                        }
                                                        else {
                                                            if let url = URL(string: partnerData.id) {
                                                                openURL(url)
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
//                                    Button(action: {
//                                        state.showCertifiedOrCompatible = .compatible
//                                    }) {
//                                        HStack {
//                                            Image("meeCompatibleLogo").resizable().scaledToFit().frame(width: 20)
//                                            BasicText(text:"Mee-compatible?", color: Colors.meeBrand, size: 14, underline: true)
//                                        }
//                                    }
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

                    } else if state.showWelcome == .FIRST {
                        FirstRunPageWelcome(imageName: "meeWelcome1") {
                            state.showWelcome = .SECOND
                        }
                    } else {
                        FirstRunPageWelcome(imageName: "meeWelcome2") {
                            state.showWelcome = .NONE
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
