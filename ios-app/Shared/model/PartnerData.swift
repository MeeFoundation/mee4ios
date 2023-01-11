//
//  PartnerData.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 3.10.22..
//

import Foundation

struct PartnerData: Codable, Identifiable {
    var id: String {
        return client_id
    }
    let client_id: String
    let name: String
    let acceptUrl: String
    let rejectUrl: String
    let displayUrl: String
    let logoUrl: String
    let type: ClientType
    var isMobileApp: Bool {
        return type == .mobile
    }
    let isMeeCertified: Bool
    init(client_id: String,
         name: String,
         acceptUrl: String,
         rejectUrl: String,
         displayUrl: String,
         logoUrl: String,
         isMeeCertified: Bool
    ) {
        self.client_id = client_id
        self.name = name
        self.acceptUrl = acceptUrl
        self.rejectUrl = rejectUrl
        self.displayUrl = displayUrl
        self.logoUrl = logoUrl
        self.type = .web
        self.isMeeCertified = isMeeCertified
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let client_id = try container.decodeIfPresent(String.self, forKey: .client_id),
              let name = try container.decodeIfPresent(String.self, forKey: .name),
              let acceptUrl = try container.decodeIfPresent(String.self, forKey: .acceptUrl),
              let rejectUrl = try container.decodeIfPresent(String.self, forKey: .rejectUrl),
              let displayUrl = try container.decodeIfPresent(String.self, forKey: .displayUrl),
              let logoUrl = try container.decodeIfPresent(String.self, forKey: .logoUrl)
        else {
            throw DecodingError.typeMismatch(PartnerData.self, .init(codingPath: decoder.codingPath, debugDescription: "Strict \(ConsentConfiguration.self) does not use all keys from decoder"))
        }
        
        self.client_id = client_id
        self.isMeeCertified = (CertifiedPartnersState.shared.partners.first{item in client_id == item.client_id} != nil)
        self.name = name
        self.acceptUrl = acceptUrl
        self.rejectUrl = rejectUrl
        self.displayUrl = displayUrl
        self.logoUrl = logoUrl
        if let type = try container.decodeIfPresent(ClientType.self, forKey: .type) {
            self.type = type
        } else {
            self.type = .web
        }
        
        
    }
    
}
