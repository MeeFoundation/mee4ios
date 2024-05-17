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
    class ConnectionsListPageViewModel: ObservableObject, MeeAgentStoreListener {
        @Published var selection: String? = nil
        @Published var connections: [MeeConnectionWrapper]?
        @Published var showedConnections: [MeeConnectionWrapper]?
        @Published var otherPartnersWebApp: [MeeConnectorWrapper]?
        @Published var showCertifiedOrCompatible: CertifiedOrCompatible? = nil
        @Published var showCompatibleWarning: Bool = false
        @Published var showIntroScreensSwitch: Bool = false
        @Published var isTagsMenuActive: Bool = false
        
        @Published var allTags: [OtherPartyTagUniffi] = []
        @Published var tagSearchString: String?
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
        
        @Published var selectedTags: Set<OtherPartyTagUniffi> = Set([]) { didSet {
            Task {
                await filterCurrentConnections()
            }
        }}
        
        init() {
            self.id = UUID()
        }
        
        var id: UUID
        @MainActor var registry = PartnersRegistry.shared
        @MainActor var core: MeeAgentStore?
        @MainActor var openURL: ((_ url: URL) -> Void)?
        
        @MainActor func setup(core: MeeAgentStore, openURL: @escaping (_ url: URL) -> Void) {
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
        
        @MainActor private func getConnectors() async {
            currentConnectors = await core?.getAllConnectors() ?? []
        }
        
        @MainActor private func getTags() async {
            allTags = await core?.getAllTags() ?? []
        }
        
        @MainActor private func getConnections() async {
            connections = await core?.getAllConnections() ?? []
        }
        
        @MainActor private func filterCurrentConnections() async {
            let filteredConnectors = getCurrentConnectors(connections: connections ?? [], searchString: connectorsSearchString, tags: self.selectedTags)
            await MainActor.run {
                refreshPartnersList(connections: filteredConnectors)
            }
        }
        
        @MainActor func onUpdate(isFirstRender: Bool) {
            Task.init {
                await getConnectors()
                await getConnections()
                await filterCurrentConnections()
                await getTags()
            }
        }
        
        @MainActor private func getCurrentConnectors(connections: [MeeConnectionWrapper], searchString: String?, tags: Set<OtherPartyTagUniffi>) -> [MeeConnectionWrapper] {
            return connections.filter { connection in
                var shouldShow = true
                if !tags.isEmpty {
                    shouldShow = !tags.intersection(connection.tags).isEmpty
                }
                guard let searchString, !searchString.isEmpty else {
                    return shouldShow
                }
                if let scoreName = connection.name.confidenceScore(searchString)
                {
                    shouldShow = scoreName < 0.5 && shouldShow
                }
                
                return shouldShow
            }
        }
        
        @MainActor private func refreshPartnersList(connections: [MeeConnectionWrapper]) {
            showedConnections = connections
            
            otherPartnersWebApp = registry.partners.filter { context in
                let isNotPresentedInExistingList = currentConnectors.firstIndex{$0.name == context.name} == nil
                return isNotPresentedInExistingList || context.isGapi
                
            }
        }
        
        @MainActor func onEntryClick(id: String) {
            selection = id
        }
        
    }
}
