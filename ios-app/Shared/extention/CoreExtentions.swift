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
    }
}

extension OidcClientMetadata {
    init(from: PartnerMetadata) {
        self.applicationType = from.type.rawValue
        self.clientName = from.name
        self.logoUri = from.logoUrl
        self.contacts = from.contacts
        self.jwks = from.jwks
    }
}

extension OidcClaimParams {
    init(from: ConsentRequestClaim) {
        self.essential = from.isRequired
        self.attributeType = from.attributeType
        self.name = from.name
        self.typ = from.type.rawValue
        self.retentionDuration = from.retentionDuration == .ephemeral ? RetentionDuration.ephemeral : from.retentionDuration == .whileUsingApp ? RetentionDuration.whileUsingApp : RetentionDuration.untilConnectionDeletion
        self.businessPurpose = from.businessPurpose
        self.isSensitive = from.isSensitive
        self.value = from.value
    }
}
