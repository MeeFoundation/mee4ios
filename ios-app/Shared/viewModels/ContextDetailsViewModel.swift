//
//  ContextDetailsViewModel.swift
//  mee-extension
//
//  Created by Anthony Ivanov on 6.11.23..
//

import Foundation

extension ContextDetailsPage {
    
    @MainActor class ContextDetailsViewModel: ObservableObject {
        @Published private(set) var connector: MeeConnectorWrapper
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
        
        init(connector: MeeConnectorWrapper) {
            self.connector = connector
        }
        
        func removeConnector(with core: MeeAgentStore) async {
            Task.init {
                try await core.removeConnector(connector: connector)
            }
        }
        
        func saveValues(with core: MeeAgentStore) {
            switch (consentEntries) {
            case .ExternalEntries(let externalEntries):
                switch externalEntries.data {
                case .meeBrowserExtension(_):
                    if let currentEntry = externalEntriesOptional.first(where: { $0.id == "gpcEnabled" }),
                       let gpcEnabled = currentEntry.value as? Bool {
                        
                        Task {
                            print("connector.otherPartyConnectionId: ", connector.otherPartyConnectionId)
                            try? await core.createExtensionConnectionAsync(url: connector.otherPartyConnectionId, gpcEnabled: gpcEnabled)
                        }
                    }
                    
                default: return
                }
            default: return
            }
        }
        
        func loadConsentData(with core: MeeAgentStore) {
            Task.init {
                if let contextData = await core.getLastConsentByConnectorId(id: connector.id) {
                    print(contextData)
                    await MainActor.run {
                        consentEntries = .SiopClaims(value: contextData.attributes)
                    }
                } else if let consentData = await core.getLastExternalConsentByConnectorId(connectorId: connector.id) {
                    await MainActor.run {
                        consentEntries = .ExternalEntries(value: consentData)
                        print("state.consentEntries: ", consentEntries)
                    }
                }
                sortConsentEntries()
                viewState = .ready
            }
        }
        
        private func sortConsentEntries() {
            switch (consentEntries) {
            case .SiopClaims(let claims):
                siopEntriesRequired = claims.filter {$0.isRequired}
                siopEntriesOptional = claims.filter {!$0.isRequired}
            case .ExternalEntries(let externalValues):
                switch externalValues.data {
                case .gapi(let gapiEntries):
                    externalEntriesOptional = Mirror(reflecting: gapiEntries.userInfo).children
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
