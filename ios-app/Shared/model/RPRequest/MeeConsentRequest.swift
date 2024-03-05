//
//  RPRequest.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 23.1.23..
//

import Foundation

struct MeeConsentRequest: Equatable {

    let id: String
    let scope: OidcScopeList
    var claims: [ConsentRequestClaim]
    let clientMetadata: PartnerMetadata
    let nonce: String
    let clientId: String
    let redirectUri: Url
    let presentationDefinition: PresentationDefinition?
    let isCrossDeviceFlow: Bool
    let sdkVersion: SdkVersion
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
        self.presentationDefinition = nil
        self.isCrossDeviceFlow = false
        self.sdkVersion = defaultSdkVersion
        self.responseType = .idToken
    }
    
    init(from: MeeContextWrapper, consentRequest: MeeConsentRequest) {
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
        self.sdkVersion = consentRequest.sdkVersion
    }
    
    init(
          claims: [ConsentRequestClaim],
          clientMetadata: PartnerMetadata,
          nonce: String,
          clientId: String,
          redirectUri: Url,
          presentationDefinition: PresentationDefinition?,
          isCrossDevice: Bool,
          sdkVersion: SdkVersion
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
          self.sdkVersion = sdkVersion
      }
    
    init?(from: OidcAuthRequest, isCrossDevice: Bool, sdkVersion: SdkVersion) {
        guard
            let clientMetadata = from.clientMetadata,
            let parnterMetaData = PartnerMetadata(from: clientMetadata),
            let claims = from.claims,
            let idToken = claims.idToken,
            let scope = from.scope,
            let redirectUri = from.redirectUri
        else {
            return nil
        }
        self.responseType = from.responseType
        self.scope = scope
        self.isCrossDeviceFlow = isCrossDevice
        self.sdkVersion = sdkVersion
        self.clientMetadata = parnterMetaData
        self.nonce = from.nonce
        self.clientId = from.clientId
        self.id = redirectUri
        self.redirectUri = redirectUri
        self.presentationDefinition = from.presentationDefinition
        self.claims = idToken
            .sorted(by: { l, r in
                l.value?.order ?? 0 < r.value?.order ?? 0
            })
            .reduce([]) { (acc: [ConsentRequestClaim], claim) in
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
