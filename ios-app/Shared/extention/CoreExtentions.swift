//
//  CoreExtentions.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 24.1.23..
//

import Foundation

extension RpAuthRequest {
    init(from: ConsentRequest) {
        self.scope = from.scope
        self.clientMetadata = OidcClientMetadata(from: from.clientMetadata)
        self.nonce = from.nonce
        self.clientId = from.clientId
        self.redirectUri = from.redirectUri
        self.presentationDefinition = from.presentationDefinition
        self.claims = OidcRequestClaimsWrapper(userinfo: nil, idToken: [:])
        self.claims?.idToken = from.claims.reduce([:]) { (acc: [String: OidcClaimParams], claim) in
            var copy = acc
            copy[claim.code] = OidcClaimParams(from: claim)
            return copy
        }
        self.responseType = from.responseType
    }
}

extension OidcClientMetadata {
    init(from: PartnerMetadata) {
        self.applicationType = from.type.rawValue
        self.clientName = from.name
        self.logoUri = from.logoUrl
        self.contacts = from.contacts
        self.jwks = from.jwks
        self.subjectSyntaxTypesSupported = from.subjectSyntaxTypesSupported
    }
}

extension OidcClaimParams {
    
    init(from: ConsentRequestClaim) {
        self.essential = from.isRequired
        self.attributeType = from.attributeType
        self.name = from.name
        self.typ = from.type.rawValue
        self.retentionDuration = from.retentionDuration == .whileUsingApp ? RetentionDuration.whileUsingApp : RetentionDuration.untilConnectionDeletion
        self.businessPurpose = from.businessPurpose
        self.isSensitive = from.isSensitive
        var val: String?
        switch from.value {
        case .card(let card): val = card.toString()
        case .ageProtect(let ageProtect): val = ageProtect.toString()
        case .string(let string): val = string
        default: return 
        }
        self.value = val
    }
}
