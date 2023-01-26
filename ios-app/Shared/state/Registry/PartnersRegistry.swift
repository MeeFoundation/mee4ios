//
//  PartnersState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import Foundation

class PartnersRegistry: ObservableObject {
    static let shared = PartnersRegistry()
    var partners: [PartnerRegistryEntry]
    
    init() {
        self.partners = [

        ]
    }
}

