//
//  RPRequest.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 23.1.23..
//

import Foundation

struct ConsentRequest {
    let id: String
    let scope: OidcScopeList
    var claims: [ConsentRequestClaim]
    let clientMetadata: PartnerMetadata
    let nonce: String
    let clientId: String
    let redirectUri: Url
    let presentationDefinition: String?
    let isCrossDeviceFlow: Bool
    let oldResponseFormat: Bool
    let responseType: OidcResponseType
    
    init() {
        self.id = ""
        self.scope = OidcScopeList(scopes: [])
        self.claims = []
        self.clientMetadata = PartnerMetadata(name: "",
                                              displayUrl: "",
                                              logoUrl: "",
                                              contacts: [])
        self.nonce = ""
        self.clientId = ""
        self.redirectUri = ""
        self.presentationDefinition = ""
        self.isCrossDeviceFlow = false
        self.oldResponseFormat = false
        self.responseType = .idToken
    }
    
    init(from: Context, consentRequest: ConsentRequest) {
        self.id = from.id
        self.scope = OidcScopeList(scopes: [OidcScope.openid])
        self.claims = from.attributes
        self.clientMetadata = consentRequest.clientMetadata
        self.nonce = consentRequest.nonce
        self.clientId = consentRequest.clientId
        self.redirectUri = consentRequest.redirectUri
        self.presentationDefinition = consentRequest.presentationDefinition
        self.isCrossDeviceFlow = consentRequest.isCrossDeviceFlow
        self.responseType = consentRequest.responseType
        self.oldResponseFormat = consentRequest.oldResponseFormat
    }
    
    init(
          claims: [ConsentRequestClaim],
          clientMetadata: PartnerMetadata,
          nonce: String,
          clientId: String,
          redirectUri: Url,
          presentationDefinition: String?,
          isCrossDevice: Bool,
          oldResponseFormat: Bool
      ) {
          self.scope = OidcScopeList(scopes: [OidcScope.openid])
          self.claims = claims
          self.clientMetadata = clientMetadata
          self.nonce = nonce
          self.clientId = clientId
          self.redirectUri = redirectUri
          self.presentationDefinition = presentationDefinition
          self.isCrossDeviceFlow = isCrossDevice
          self.id = redirectUri
          self.responseType = .idToken
          self.oldResponseFormat = oldResponseFormat
      }
    
    init?(from: RpAuthRequest, isCrossDevice: Bool, oldResponseFormat: Bool) {
        guard
            let parnterMetaData = PartnerMetadata(from: from.clientMetadata),
            let claims = from.claims,
            let idToken = claims.idToken
        else {
            return nil
        }
        self.responseType = from.responseType
        self.scope = from.scope
        self.isCrossDeviceFlow = isCrossDevice
        self.oldResponseFormat = oldResponseFormat
        self.clientMetadata = parnterMetaData
        self.nonce = from.nonce
        self.clientId = from.clientId
        self.id = from.redirectUri
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
