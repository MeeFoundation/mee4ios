//
//  PartnersState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import Foundation

class PartnersRegistry: ObservableObject {
    static let shared = PartnersRegistry()
    var partners: [MeeConnectorWrapper]
    
    init() {
        self.partners = [
            MeeConnectorWrapper(id: "https://oldeyorktimes.com/", name: "The Olde York Times", otherPartyConnectionId: "", connectorProtocol: .Siop(value: SiopConnectorProtocol(redirectUri: "https://oldeyorktimes.com/", clientMetadata: PartnerMetadata(name: "The Olde York Times", displayUrl: "oldeyorktimes.com", logoUrl: "https://oldeyorktimes.com/favicon.png", contacts: []), subject: .DidKey(value: "")))),
            MeeConnectorWrapper(id: "https://google.com", name: "Google Account", otherPartyConnectionId: "", connectorProtocol: .Gapi(value: GapiConnectorProtocol(scopes: []))),
            
        ]
    }
}



