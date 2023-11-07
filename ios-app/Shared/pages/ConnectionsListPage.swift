//
//  ConsentsList.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct ConnectionsListPage: View, MeeAgentStoreListener {
    @EnvironmentObject var core: MeeAgentStore
    var registry = PartnersRegistry.shared
    @EnvironmentObject var navigationState: NavigationState
    
    @State private var state = ConsentsListState()
    @Environment(\.openURL) var openURL
    @EnvironmentObject private var appState: AppState
    
    var id = UUID()
    func onUpdate() {
        onUpdate(isFirstRender: false)
    }
    
    
    func onUpdate(isFirstRender: Bool) {
        
        Task.init {
            let currentConnections = await core.getAllConnectors()
            await MainActor.run {
                refreshPartnersList(data: currentConnections)
            }
        }
    }
    
    init() {
        
    }
    
    
    func refreshPartnersList(data: [MeeConnectorWrapper]) {
        state.existingPartnersWebApp = data.filter{ context in
            switch (context.connectorProtocol) {
            case .Siop(let value):
                return value.clientMetadata.type == .web
            case .Gapi(_):
                return true
            case .MeeBrowserExtension:
                return true
            default: return false
            }
        }
        state.existingPartnersMobileApp = data.filter{ context in
            if case let .Siop(value) = context.connectorProtocol {
                return value.clientMetadata.type == .mobile
            }
            return false
        }
        state.otherPartnersWebApp = registry.partners.filter { context in
            let isNotPresentedInExistingList = state.existingPartnersWebApp?.firstIndex{$0.name == context.name} == nil
            return isNotPresentedInExistingList || context.isGapi
            
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
                        HStack {
                            Button(action: {
                                withAnimation() {
                                    appState.isSlideMenuOpened.toggle()
                                }
                                
                            }) {
                                Image("menuIcon")
                            }
                            
                            Spacer()
                            BasicText(
                                text: "Connections",
                                color: .white ,
                                size: 17,
                                fontName: FontNameManager.PublicSans.semibold,
                                weight: .semibold
                            )
                            Spacer()
                            ZStack{}
                                .frame(width: 24)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 59)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 9)
                        .background(Colors.meeBrand)
                        .shadow(color: Color.black.opacity(0.3), radius: 0, x: 0, y: 0.5)
                        ScrollView {
                            VStack {
                                ForEach([PartnerArray(data: state.existingPartnersWebApp, name: "Sites", editable: true),
                                         PartnerArray(data: state.existingPartnersMobileApp, name: "Mobile Apps", editable: true),
//                                         PartnerArray(data: state.otherPartnersWebApp, name: "Sites to connect to", editable: false)
                                        ]) { partnersArray in
                                    if !(partnersArray.data ?? []).isEmpty {
                                        HStack {
                                            BasicText(text: partnersArray.name, color: Colors.text, size: 16, fontName: FontNameManager.PublicSans.medium)
                                            Spacer()
                                        }
                                        .padding(.leading, 4)
                                        .padding(.top, 24)
                                        .padding(.bottom, 4)
                                    }
                                    ForEach(partnersArray.data ?? []) { partnerData in
                                        NavigationLink(
                                            destination: ContextDetailsPage(connector: partnerData),
                                            tag: partnerData.id,
                                            selection: $state.selection
                                        ){}
                                        PartnerEntry(connector: partnerData, hasEntry: partnersArray.editable)
                                            .onTapGesture(perform: {
                                                if partnersArray.editable {
                                                    state.selection = partnerData.id
                                                    
                                                }
                                                else {
                                                    switch (partnerData.connectorProtocol) {
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
//                        VStack {
//                            Button(action: {
//                                state.showCertifiedOrCompatible = .certified
//                            }) {
//                                HStack {
//                                    Image("meeCertifiedLogo").resizable().scaledToFit().frame(width: 20)
//                                    BasicText(text:"Mee-certified?", color: Colors.meeBrand, size: 14, underline: true)
//                                }
//                            }
//
//                        }
//                        .padding(.bottom, 20)
//                        .padding(.top, 10)
//                        .frame(maxWidth: .infinity)
//                        .background(Color.white)
                        
                    }
                    .background(Color.white)
                    
                }
                .ignoresSafeArea(.all)
                .background(Color.white)
                .frame(maxWidth: .infinity)
            }
            
        }
        .onAppear {
            core.addListener(self)
            onUpdate(isFirstRender: true)
        }
        .onDisappear {
            core.removeListener(self)
        }
        .overlay {
            PlusMenu(availableItems: state.otherPartnersWebApp ?? [])
        }
        .ignoresSafeArea(.all)
        
        
        
    }
}

