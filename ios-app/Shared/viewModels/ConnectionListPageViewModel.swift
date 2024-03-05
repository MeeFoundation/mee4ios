//
//  ConnectionListPageViewModel.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 17.11.23..
//

import Foundation

enum WelcomeType {
    case NONE
    case FIRST
    case SECOND
}

extension ConnectionsListPage {
    @MainActor class ConnectionsListPageViewModel: ObservableObject, MeeAgentStoreListener {
        @Published var selection: String? = nil
        @Published var connections: [MeeConnectionWrapper]?
        @Published var showedConnections: [MeeConnectionWrapper]?
        @Published var otherPartnersWebApp: [MeeConnectorWrapper]?
        @Published var showCertifiedOrCompatible: CertifiedOrCompatible? = nil
        @Published var showCompatibleWarning: Bool = false
        @Published var showIntroScreensSwitch: Bool = false
        @Published var showSearchBar: Bool = false { didSet {
            connectorsSearchString = ""
        }}
        private var currentConnectors: [MeeConnectorWrapper] = [] { didSet {
            Task {
                await filterCurrentConnections()
            }
        }}
        @Published var connectorsSearchString: String? = nil { didSet {
            Task {
                await filterCurrentConnections()
            }
        }}
        init() {
            self.id = UUID()
        }
        
        var id: UUID
        var registry = PartnersRegistry.shared
        var core: MeeAgentStore?
        var openURL: ((_ url: URL) -> Void)?
        
        func setup(core: MeeAgentStore, openURL: @escaping (_ url: URL) -> Void) {
            core.addListener(self)
            self.core = core
            self.openURL = openURL
        }
        
        deinit {
            core?.removeListener(self)
        }
        
        nonisolated func onUpdate() {
            Task {
                await MainActor.run {
                    onUpdate(isFirstRender: false)
                }
            }
            
        }
        
        private func getConnectors() async {
            currentConnectors = await core?.getAllConnectors() ?? []
        }
        
        private func getConnections() async {
            connections = await core?.getAllConnections() ?? []
        }
        
        private func filterCurrentConnections() async {
            let filteredConnectors = getCurrentConnectors(connections: connections ?? [], searchString: connectorsSearchString)
            await MainActor.run {
                refreshPartnersList(connections: filteredConnectors)
            }
        }
        
        func onUpdate(isFirstRender: Bool) {
            Task.init {
                await getConnectors()
                await getConnections()
                await filterCurrentConnections()
            }
        }
        
        private func getCurrentConnectors(connections: [MeeConnectionWrapper], searchString: String?) -> [MeeConnectionWrapper] {
            return connections.filter { connection in
                guard let searchString, !searchString.isEmpty else { return true }
                if let scoreName = connection.name.confidenceScore(searchString)
                {
                    return scoreName < 0.5
                }
                return true
            }
        }
        
        private func refreshPartnersList(connections: [MeeConnectionWrapper]) {
            showedConnections = connections
            
            otherPartnersWebApp = registry.partners.filter { context in
                let isNotPresentedInExistingList = currentConnectors.firstIndex{$0.name == context.name} == nil
                return isNotPresentedInExistingList || context.isGapi
                
            }
        }
        
        func onEntryClick(id: String) {
            selection = id
        }
        
    }
}
