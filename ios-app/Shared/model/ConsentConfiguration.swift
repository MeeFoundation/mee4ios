//
//  ConsentConfiguration.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 14.12.22..
//

import Foundation

struct ConsentConfiguration: Codable {
    var client_id: String?
    var client: PartnerData?
    var env: MeeEnv?
    var scope: String?
    var claim: [String: MeeClaimItem]?
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        if let client = try container.decodeIfPresent(PartnerData.self, forKey: .client) {
            self.client = client
            self.client_id = client.client_id
        } else {
            print("Catch!")
            if let client_id = try container.decodeIfPresent(String.self, forKey: .client_id) {
                self.client_id = client_id
                guard let certifiedPartner = PartnersState.shared.partners.first(where: {p in
                    p.client_id == client_id
                }) else {
                    throw DecodingError.typeMismatch(ConsentConfiguration.self, .init(codingPath: decoder.codingPath, debugDescription: "Strict \(ConsentConfiguration.self) does not use all keys from decoder"))
                }
                self.client = certifiedPartner
            }
        }
        
        
        
        
        if let env = try container.decodeIfPresent(MeeEnv.self, forKey: .env) {
            self.env = env
        }
        if let scope = try container.decodeIfPresent(String.self, forKey: .scope) {
            self.scope = scope
        }
        if let claim = try container.decodeIfPresent([String: MeeClaimItem].self, forKey: .claim) {
            self.claim = claim
        }
    }
}
