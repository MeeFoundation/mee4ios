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
        @Published var existingPartnersWebApp: [MeeConnectorWrapper]?
        @Published var otherPartnersWebApp: [MeeConnectorWrapper]?
        @Published var existingPartnersMobileApp: [MeeConnectorWrapper]?
        @Published var otherPartnersMobileApp: [MeeConnectorWrapper]?
        @Published var showCertifiedOrCompatible: CertifiedOrCompatible? = nil
        @Published var showCompatibleWarning: Bool = false
        @Published var showIntroScreensSwitch: Bool = false
        @Published var showSearchBar: Bool = false { didSet {
            connectorsSearchString = ""
        }}
        private var currentConnectors: [MeeConnectorWrapper] = [] { didSet {
            Task {
                await filterCurrentConnectors()
            }
        }}
        @Published var connectorsSearchString: String? = nil { didSet {
            Task {
                await filterCurrentConnectors()
            }
        }}
        
        var id = UUID()
        var registry = PartnersRegistry.shared
        var core: MeeAgentStore?
        var openURL: ((_ url: URL) -> Void)?
        
        func setup(core: MeeAgentStore, openURL: @escaping (_ url: URL) -> Void) {
            core.addListener(self)
            self.core = core
            self.openURL = openURL
        }
        
        deinit {
            core?.addListener(self)
        }
        
        func onUpdate() {
            onUpdate(isFirstRender: false)
        }
        
        private func getConnectors() async {
            currentConnectors = await core?.getAllConnectors() ?? []
        }
        
        private func filterCurrentConnectors() async {
            let filteredConnectors = getCurrentConnectors(connectors: currentConnectors, searchString: connectorsSearchString)
            await MainActor.run {
                refreshPartnersList(connectors: filteredConnectors)
            }
        }
        
        func onUpdate(isFirstRender: Bool) {
            Task.init {
                await getConnectors()
            }
        }
        
        private func getCurrentConnectors(connectors: [MeeConnectorWrapper], searchString: String?) -> [MeeConnectorWrapper] {
            return connectors.filter { connector in
                guard let searchString, !searchString.isEmpty else { return true }
                if let scoreName = connector.name.confidenceScore(searchString),
                   let scoreConnectionType = connector.connectorType.confidenceScore(searchString)
                {
                    print(scoreName, connector.name, scoreConnectionType, connector.id, searchString)
                    return scoreName < 0.6 || scoreConnectionType < 0.6
                }
                return true
            }
        }
        
        private func refreshPartnersList(connectors: [MeeConnectorWrapper]) {
            existingPartnersWebApp = connectors.filter{ context in
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
            existingPartnersMobileApp = connectors.filter{ context in
                if case let .Siop(value) = context.connectorProtocol {
                    return value.clientMetadata.type == .mobile
                }
                return false
            }
            otherPartnersWebApp = registry.partners.filter { context in
                let isNotPresentedInExistingList = existingPartnersWebApp?.firstIndex{$0.name == context.name} == nil
                return isNotPresentedInExistingList || context.isGapi
                
            }
        }
        
        func onEntryClick(id: String) {
                selection = id
        }
        
    }
}
