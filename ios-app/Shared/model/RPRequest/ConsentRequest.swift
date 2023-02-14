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
    let isCrossDeviceFlow: Bool
    
    init(from: Context, clientId: String = "", nonce: String = "", redirectUri: String = "", isCrossDevice: Bool = false, clientMetadata: PartnerMetadata? = nil) {
        self.scope = OidcScopeWrapper.set(scope: [OidcScope.openid])
        self.claims = from.claims
        self.clientMetadata = clientMetadata ?? from.clientMetadata
        self.nonce = nonce
        self.clientId = clientId
        self.redirectUri = redirectUri
        self.presentationDefinition = ""
        self.isCrossDeviceFlow = isCrossDevice
    }
    
    init(
        claims: [ConsentRequestClaim],
        clientMetadata: PartnerMetadata,
        nonce: String,
        clientId: String,
        redirectUri: Url,
        presentationDefinition: String?,
        isCrossDevice: Bool
    ) {
        self.scope = OidcScopeWrapper.set(scope: [OidcScope.openid])
        self.claims = claims
        self.clientMetadata = clientMetadata
        self.nonce = nonce
        self.clientId = clientId
        self.redirectUri = redirectUri
        self.presentationDefinition = presentationDefinition
        self.isCrossDeviceFlow = isCrossDevice
    }
    
    init?(from: RpAuthRequest, isCrossDevice: Bool) {
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
        self.isCrossDeviceFlow = isCrossDevice
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
