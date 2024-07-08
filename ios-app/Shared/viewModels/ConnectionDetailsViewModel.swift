//
//  ContextDetailsViewModel.swift
//  mee-extension
//
//  Created by Anthony Ivanov on 6.11.23..
//

import Foundation

extension ConnectionDetailsPage {
    
    class ConnectionDetailsViewModel: ObservableObject, MeeAgentStoreListener {
        var id: UUID
        
        @MainActor var core: MeeAgentStore?
        
        nonisolated func onUpdate() {
            Task {
                await MainActor.run {
                    if let core {
                        loadConnectors(with: core)
                        
                    }
                }
            }
        }
        
        @Published private(set) var connection: MeeConnectionWrapper
        @Published private(set) var connectors: [MeeConnectorWrapper]?
        @Published var currentConnector: String?
        @Published var durationPopupId: UUID? = nil
        @Published private(set) var consentEntries: ConsentEntriesType? = nil
        @Published var siopEntriesRequired: [ConsentRequestClaim] = []
        @Published var siopEntriesOptional: [ConsentRequestClaim] = []
        @Published var externalEntriesOptional: [ConsentExternalClaim] = []
        @Published var isRequiredOpen: Bool = true
        @Published var isOptionalOpen: Bool = false
        @Published private(set) var selection: String? = nil
        @Published private(set) var scrollPosition: UUID?
        @Published private(set) var viewState: ViewState = .loading
        @Published var showConnectorRemoveDialog: Bool = false
        @Published var showConnectionRemoveDialog: Bool = false
        @Published var allTags: [OtherPartyTagUniffi] = []
        @Published var tagSearchString: String? 
        @Published var isTagsMenuActive: Bool = false
        
        @Published var selectedTags: Set<OtherPartyTagUniffi> = Set([]) { didSet {
            Task {
                await core?.assignTagsToConnection(connectionId: connection.id, tags: Array(selectedTags))
            }
        }}
        
        @MainActor init(connection: MeeConnectionWrapper) {
            self.connection = connection
            self.id = UUID()
        }
        
        @MainActor func setup(core: MeeAgentStore) {
            core.addListener(self)
            self.core = core
        }
        
        @MainActor func getTags() async {
            allTags = await core?.getAllTags() ?? []
            print("connection.tags: ", connection.tags)
            selectedTags = Set(connection.tags)
        }
        
        @MainActor func removeConnector(with core: MeeAgentStore) async {
            do {
                viewState = .loading
                if let connector = connectors?.first(where: {$0.id == currentConnector}) {
                    try await core.removeConnector(connector: connector)
                }
                viewState = .ready
            } catch {
                viewState = .ready
            }
            
        }
        
        @MainActor func getConnectorName() -> String {
            if let connector = connectors?.first(where: {$0.id == currentConnector}) {
                return switch(connector.connectorProtocol) {
                case .Gapi( _): "Account"
                case .MeeBrowserExtension: "Extension"
                case .MeeTalk: "Mee Talk"
                case .Siop( _): "Profile"
                case .openId4Vc( _): "Openid 4 VC"
                }
            }
            return "Connector"
        }
        
        @MainActor func saveValues(with core: MeeAgentStore) {
            switch (consentEntries) {
            case .ExternalEntries(let externalEntries):
                switch externalEntries.data {
                case .meeBrowserExtension(_):
                    if let currentEntry = externalEntriesOptional.first(where: { $0.id == "gpcEnabled" }),
                       let gpcEnabled = currentEntry.value as? Bool {
                        
                        Task {
//                            print("connector.otherPartyConnectionId: ", connector.otherPartyConnectionId)
//                            try? await core.createExtensionConnectionAsync(url: connector.otherPartyConnectionId, gpcEnabled: gpcEnabled)
                        }
                    }
                    
                default: return
                }
            default: return
            }
        }
        
        @MainActor func loadConnectors(with core: MeeAgentStore) {
            Task {
                let connectors = await core.getAllConnectionConnectors(connectionId: connection.id)
                if connectors.count != 0 {
                    currentConnector = connectors.first?.id
                }
                self.connectors = connectors
                viewState = .ready
            }
        }
        
        @MainActor func loadConsentData(with core: MeeAgentStore) {
            if let currentConnector {
                Task.init {
                    if let contextData = await core.getLastConsentByConnectorId(id: currentConnector) {
                        print(contextData)
                        await MainActor.run {
                            consentEntries = .SiopClaims(value: contextData.attributes)
                        }
                    } else if let consentData = await core.getLastExternalConsentByConnectorId(connectorId: currentConnector) {
                        await MainActor.run {
                            consentEntries = .ExternalEntries(value: consentData)
                            print("state.consentEntries: ", consentEntries)
                        }
                    }
                    sortConsentEntries()
                    viewState = .ready
                }
            }
        }
        
        @MainActor private func sortConsentEntries() {
            switch (consentEntries) {
            case .SiopClaims(let claims):
                siopEntriesRequired = claims.filter {$0.isRequired}
                siopEntriesOptional = claims.filter {!$0.isRequired && !$0.isEmpty}
            case .ExternalEntries(let externalValues):
                switch externalValues.data {
                case .gapi(let gapiEntries):
                    externalEntriesOptional = Mirror(reflecting: gapiEntries.userInfo).children
                        .sorted(by: { l, r in
                            l.label ?? "" < r.label ?? ""
                        })
                        .reduce([]){ (acc: [ConsentExternalClaim] , item) in
                            var copy = acc
                            if let value = item.value as? String,
                               let label = item.label
                            {
                                if item.label == "familyName" ||
                                   item.label == "givenName" ||
                                   item.label == "email" {
                                    copy.append(.init(id: label, name: label, value: value))
                                }
                                
                            }
                            return copy
                        }
                case .meeBrowserExtension(let browserExtensionEntries):
                    let browserExtensionEntriesArray: [ConsentExternalClaim] = [.init(id: "gpcEnabled", name: "Gpc Enabled", value: browserExtensionEntries.gpcEnabled)]
                    externalEntriesOptional = browserExtensionEntriesArray
                default:
                    return
                }
                
            case .none:
                return
            }
            
        }
    }
}
