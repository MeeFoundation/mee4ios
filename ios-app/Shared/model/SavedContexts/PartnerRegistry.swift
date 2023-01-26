//
//  PartnerRegistry.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 23.1.23..
//

import Foundation

//
//  PartnerData.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 3.10.22..
//

import Foundation

struct PartnerRegistryEntry: Codable, Identifiable {
    var id: String {
        return clientId
    }
    let clientId: String
    let name: String
    let displayUrl: String
    let logoUrl: String
    let type: ClientType
    let isMeeCertified: Bool
    
    init(clientId: String,
         name: String,
         url: String,
         displayUrl: String,
         logoUrl: String,
         isMeeCertified: Bool
    ) {
        self.clientId = clientId
        self.name = name
        self.displayUrl = displayUrl
        self.logoUrl = logoUrl
        self.type = .web
        self.isMeeCertified = isMeeCertified
    }
    
}
