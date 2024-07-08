//
//  ConsentDetails.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct ConnectionDetailsPage: View {
    @EnvironmentObject var core: MeeAgentStore
    @EnvironmentObject var navigationState: NavigationState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel: ConnectionDetailsViewModel
    
    init(connection: MeeConnectionWrapper) {
        _viewModel = StateObject(wrappedValue: ConnectionDetailsViewModel(connection: connection))
    }
    var body: some View {
        return (
            
            VStack(spacing: 0) {
                if viewModel.viewState == .loading {
                    ProgressView()
                } else {
                    Header(text: "Manage Connection") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                    
                    ZStack(alignment: Alignment.topLeading) {
                        
                        ScrollViewReader { proxy in
                            ScrollView {
                                PartnerEntry(connection: viewModel.connection, hasEntry: false) {
                                    viewModel.showConnectionRemoveDialog = true
                                }
                                .border(Colors.meeBrand, width: 2)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 24)
                                .padding(.top, 16)
                                
                                TagFilter(text: "Tags", isTagsMenuActive: $viewModel.isTagsMenuActive, selectedTags: $viewModel.selectedTags, tags:  $viewModel.allTags, filter: $viewModel.tagSearchString, showBadge: false, onCreateNew: { newTagName in
                                    Task {
                                        await core.createTag(tag: newTagName)
                                        await viewModel.getTags()
                                    }
                                    
                                })
                                .padding(.horizontal, 16)
                                Divider()
                                    .frame(height: 1)
                                    .background(Colors.gray)
                                    .padding(.vertical, 24)
                                
                                ConnectorTabs(connectors: viewModel.connectors ?? [], currentConnector: $viewModel.currentConnector)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 24)
                                if viewModel.siopEntriesRequired.count > 0 {
                                    Expander(title: "Required info shared", isOpen: $viewModel.isRequiredOpen) {
                                        ForEach($viewModel.siopEntriesRequired) { $entry in
                                            VStack {
                                                ConsentEntry(entry: $entry, isReadOnly: true) {
                                                    viewModel.durationPopupId = entry.id
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
                                }
                                if viewModel.siopEntriesOptional.count > 0 {
                                    Expander(title: "Optional info shared", isOpen: $viewModel.isOptionalOpen) {
                                        ForEach($viewModel.siopEntriesOptional) { $entry in
                                            VStack {
                                                ConsentEntry(entry: $entry, isReadOnly: true) {
                                                    viewModel.durationPopupId = entry.id
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
                                
                                ForEach($viewModel.externalEntriesOptional, id: \.self.id) { $entry in
                                    ExternalConsentEntry(name: entry.name, value: $entry.value)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.showConnectorRemoveDialog = true
                                }){
                                    HStack(spacing: 0) {
                                        BasicText(text: "Delete \(viewModel.getConnectorName())", color: Colors.error, size: 17)
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
                }
                
            }
                .onTapGesture {
                    if (viewModel.isTagsMenuActive) {
                        withAnimation {
                            viewModel.isTagsMenuActive = false
                        }
                    }
                }
                .overlay {
                    ZStack {
                        BackgroundFaded()
                        VStack {
                            Spacer()
                            DestructionConfirmationDialog(text: "Delete \(viewModel.getConnectorName())", description: "Are you sure you want to delete the \(viewModel.getConnectorName())?", buttonText: "Yes, delete \(viewModel.getConnectorName())",
                                                          buttonTextColor: Colors.error,
                                                          onNext: {
                                Task {
                                    viewModel.showConnectorRemoveDialog = false
                                    await viewModel.removeConnector(with: core)
                                    self.presentationMode.wrappedValue.dismiss()
                                   
                                }
                            }, onCancel: {
                                viewModel.showConnectorRemoveDialog = false
                            })
                        }
                    }
                    .opacity(viewModel.showConnectorRemoveDialog ? 1 : 0)
                }
                .overlay {
                    ZStack {
                        BackgroundFaded()
                        VStack {
                            Spacer()
                            DestructionConfirmationDialog(text: "Delete connection", description: "Are you sure you want to delete the connection?", buttonText: "Yes, delete connection",
                                                          buttonTextColor: Colors.error,
                                                          onNext: {
                                Task {
                                    do {
                                        try await core.removeConnection(connection: viewModel.connection)
                                    } catch {
                                        
                                    }
                                }
                            }, onCancel: {
                                viewModel.showConnectionRemoveDialog = false
                            })
                        }
                    }
                    .opacity(viewModel.showConnectionRemoveDialog ? 1 : 0)
                }
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                .onAppear{
                    viewModel.setup(core: core)
                    viewModel.loadConsentData(with: core)
                    viewModel.loadConnectors(with: core)
                    
                }
                .task {
                    await viewModel.getTags()
                }
                .onChange(of: viewModel.currentConnector) {_ in
                    viewModel.loadConsentData(with: core)
                }
                .onChange(of: viewModel.connectors) { updatedConnectors in
                    if (updatedConnectors?.count == 0) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                .onChange(of: viewModel.externalEntriesOptional) {newValue in
                    viewModel.saveValues(with: core)
                }
        )
        
    }
    
}


