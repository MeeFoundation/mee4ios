//
//  ConsentsList.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct ConnectionsListPage: View {
    @EnvironmentObject var core: MeeAgentStore
    @EnvironmentObject var navigationState: NavigationState
    @Environment(\.openURL) var openURL
    @EnvironmentObject private var appState: AppState
    @StateObject var viewModel = ConnectionsListPageViewModel()
    
    var body: some View {
        
        ZStack {
            if viewModel.showCertifiedOrCompatible != nil {
                VStack {
                    if let certifiedUrl {
                        if let compatibleUrl {
                            WebView(url: viewModel.showCertifiedOrCompatible == .certified ? certifiedUrl : compatibleUrl)
                                .padding(.horizontal, 10)
                        }
                        
                    }
                    
                    SecondaryButton("Close", action: {
                        viewModel.showCertifiedOrCompatible = nil
                    })
                    .padding(.bottom, 10)
                }
            } else {
                ZStack {
                    VStack {
                        HStack {
                            if (viewModel.showSearchBar) {
                                SearchInput("Search", text: $viewModel.connectorsSearchString)
                                Spacer()
                                Button(action: {
                                    withAnimation() {
                                        viewModel.showSearchBar.toggle()
                                    }
                                    
                                }) {
                                    BasicText(text: "Cancel", color: .white, size: 17)
                                }
                                .padding(.leading, 16)
                            } else {
                                BasicText(
                                    text: "Connections",
                                    color: .white ,
                                    size: 18,
                                    fontName: FontNameManager.PublicSans.semibold,
                                    weight: .bold
                                )
                                Spacer()
                                Button(action: {
                                    withAnimation() {
                                        viewModel.showSearchBar.toggle()
                                    }
                                    
                                }) {
                                    Image("searchIcon")
                                }
                                .padding(.trailing, 8)
                                Button(action: {
                                    withAnimation() {
                                        appState.isSlideMenuOpened.toggle()
                                    }
                                    
                                }) {
                                    Image("menuIcon")
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 59)
                        .padding(.bottom, viewModel.showSearchBar ? 10 : 22)
                        .padding(.horizontal, 16)
                        .background(Colors.meeBrand)
                        .shadow(color: Color.black.opacity(0.3), radius: 0, x: 0, y: 0.5)
                        ScrollView {
                            VStack {
                                ForEach([PartnerArray(data: viewModel.existingPartnersWebApp, name: "Sites", editable: true),
                                         PartnerArray(data: viewModel.existingPartnersMobileApp, name: "Mobile Apps", editable: true),
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
                                            selection: $viewModel.selection
                                        ){}
                                        PartnerEntry(connector: partnerData, hasEntry: partnersArray.editable)
                                            .onTapGesture(perform: {
                                                viewModel.onEntryClick(id: partnerData.id)
                                            })
                                            .padding(.top, 8)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            
                        }
                        
                    }
                    .background(Color.white)
                    
                }
                .ignoresSafeArea(.all)
                .background(Color.white)
                .frame(maxWidth: .infinity)
            }
            
        }
        .onAppear {
            viewModel.setup(core: core, openURL: { url in
                openURL(url)
            })
            viewModel.onUpdate(isFirstRender: true)
        }
        .overlay {
            PlusMenu(availableItems: viewModel.otherPartnersWebApp ?? [])
        }
        .ignoresSafeArea(.all)
        
        
        
    }
}

