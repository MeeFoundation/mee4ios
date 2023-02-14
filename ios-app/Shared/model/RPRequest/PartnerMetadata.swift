//
//  PartnerData.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 3.10.22..
//

import Foundation

struct PartnerMetadata: Codable, Identifiable {
    var id: String {
        return name
    }
    let name: String
    let displayUrl: String
    let logoUrl: String
    let type: ClientType
    let jwks: [String]?
    var isMobileApp: Bool {
        return type == .mobile
    }
    var contacts: [String]
    
    init(name: String,
         displayUrl: String,
         logoUrl: String,
         contacts: [String]
    ) {
        self.name = name
        self.displayUrl = displayUrl
        self.logoUrl = logoUrl
        self.type = .web
        self.contacts = contacts
        self.jwks = nil
    }
    
    
    init?(from: OidcClientMetadata) {
        guard
            let clientName = from.clientName,
            let logoUro = from.logoUri,
            let applicationType = from.applicationType,
            let clientType = ClientType(rawValue: applicationType) else {
                return nil
            }
        self.name = clientName
        self.displayUrl = clientName
        self.logoUrl = logoUro
        self.type = clientType
        self.contacts = from.contacts
        self.jwks = from.jwks
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard
              let name = try container.decodeIfPresent(String.self, forKey: .name),
              let displayUrl = try container.decodeIfPresent(String.self, forKey: .displayUrl),
              let logoUrl = try container.decodeIfPresent(String.self, forKey: .logoUrl),
              let contacts = try container.decodeIfPresent([String].self, forKey: .contacts)
        else {
            throw DecodingError.typeMismatch(PartnerMetadata.self, .init(codingPath: decoder.codingPath, debugDescription: "Strict \(PartnerMetadata.self) does not use all keys from decoder"))
        }
        
        self.name = name
        self.displayUrl = displayUrl
        self.logoUrl = logoUrl
        self.contacts = contacts
        self.jwks = nil
        if let type = try container.decodeIfPresent(ClientType.self, forKey: .type) {
            self.type = type
        } else {
            self.type = .web
        }
        
        
    }
    
    
}
