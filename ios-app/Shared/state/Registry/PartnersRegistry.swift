//
//  PartnersState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import Foundation

class PartnersRegistry: ObservableObject {
    static let shared = PartnersRegistry()
    var partners: [Context]
    
    init() {
        self.partners = [
            Context(id: "https://mee.foundation/", did: "", claims: [], clientMetadata: PartnerMetadata(name: "Mee Foundation", displayUrl: "mee.foundation", logoUrl: "https://mee.foundation/favicon.png", contacts: []))
        ]
    }
}

