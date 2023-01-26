//
//  RPRequest.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 23.1.23..
//

import Foundation

struct ConsentRequest {
    let scope: OidcScopeWrapper
    var claims: [ConsentRequestClaim]
    let clientMetadata: PartnerMetadata
    let nonce: String
    let clientId: String
    let redirectUri: Url
    let presentationDefinition: String?
    
    init(from: Context, nonce: String, redirectUri: String) {
        self.scope = OidcScopeWrapper.set(scope: [OidcScope.openId])
        self.claims = from.claims
        self.clientMetadata = from.clientMetadata
        self.nonce = nonce
        self.clientId = from.did
        self.redirectUri = redirectUri
        self.presentationDefinition = ""
    }
    
    init(
        claims: [ConsentRequestClaim],
        clientMetadata: PartnerMetadata,
        nonce: String,
        clientId: String,
        redirectUri: Url,
        presentationDefinition: String?
    ) {
        self.scope = OidcScopeWrapper.set(scope: [OidcScope.openId])
        self.claims = claims
        self.clientMetadata = clientMetadata
        self.nonce = nonce
        self.clientId = clientId
        self.redirectUri = redirectUri
        self.presentationDefinition = presentationDefinition
    }
    
    init?(from: RpAuthRequest) {
        guard
            let clientMetaData = from.clientMetadata,
            let parnterMetaData = PartnerMetadata(from: clientMetaData),
            let claims = from.claims,
            let idToken = claims.idToken,
            let clientId = from.clientId
        else {
            return nil
        }
        self.scope = from.scope
        self.clientMetadata = parnterMetaData
        self.nonce = from.nonce
        self.clientId = clientId
        self.redirectUri = from.redirectUri
        self.presentationDefinition = from.presentationDefinition
        self.claims = idToken.reduce([]) { (acc: [ConsentRequestClaim], claim) in
            var copy = acc
            if let value = claim.value,
               let request = ConsentRequestClaim(from: value, code: claim.key)
            {
                copy.append(request)
                return copy
            }
            return acc
        }
    }

}
