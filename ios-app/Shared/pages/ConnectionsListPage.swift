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
                    VStack(spacing: 0) {
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
                                
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 59)
                        .padding(.bottom, viewModel.showSearchBar ? 10 : 22)
                        .padding(.horizontal, 16)
                        .background(Colors.meeBrand)
                        .shadow(color: Color.black.opacity(0.3), radius: 0, x: 0, y: 0.5)
                        
                        TagFilter(text: "Filters", isTagsMenuActive: $viewModel.isTagsMenuActive, selectedTags: $viewModel.selectedTags, tags: $viewModel.allTags, filter: $viewModel.tagSearchString, onCreateNew: nil)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                        Divider()
                            .frame(height: 1)
                            .background(Colors.gray)
                            .padding(.top, 16)
                            .padding(.bottom, 16)
                        
                        ScrollView {
                            VStack {
                                if let connections = viewModel.showedConnections {
                                    ForEach(connections) { connection in
                                        NavigationLink(
                                            destination: ConnectionDetailsPage(connection: connection),
                                            tag: connection.id,
                                            selection: $viewModel.selection
                                        ){}
                                        PartnerEntry(connection: connection, hasEntry: true){}
                                            .onTapGesture(perform: {
                                                viewModel.onEntryClick(id: connection.id)
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
        .onTapGesture {
            if (viewModel.isTagsMenuActive) {
                withAnimation {
                    viewModel.isTagsMenuActive = false
                }
            }
        }
        
        
    }
}

