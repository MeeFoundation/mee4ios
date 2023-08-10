//
//  PartnersState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import Foundation

class PartnersRegistry: ObservableObject {
    static let shared = PartnersRegistry()
    var partners: [Connection]
    
    init() {
        self.partners = [
            Connection(id: "https://mee.foundation/", name: "Mee Foundation", value: .Siop(value: SiopConnectionType(redirectUri: "https://mee.foundation/", clientMetadata: PartnerMetadata(name: "Mee Foundation", displayUrl: "mee.foundation", logoUrl: "https://mee.foundation/favicon.png", contacts: []), subject: .DidKey(value: "")))),
            Connection(id: "https://oldeyorktimes.com/", name: "The Olde York Times", value: .Siop(value: SiopConnectionType(redirectUri: "https://oldeyorktimes.com/", clientMetadata: PartnerMetadata(name: "The Olde York Times", displayUrl: "oldeyorktimes.com", logoUrl: "https://oldeyorktimes.com/favicon.png", contacts: []), subject: .DidKey(value: "")))),
            Connection(id: "https://google.com", name: "Google Account", value: .Gapi(value: GapiConnectionType(scopes: [])))
        ]
    }
}



