//
//  ConsentPageState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 22.11.22..
//

import SwiftUI

struct ConsentPageState {
    var isPresentingAlert: Bool = false
    var isReturningUser: Bool?    

    
    func clearConsentsListFromDisabledOptionals (_ data: MeeConsentRequest) -> MeeConsentRequest {
        let dataClearedFromDisabledOptionals = data.claims.map { claim in
            var claimCopy = claim
            if !claim.isRequired && !claim.isOn {
                claimCopy.value = nil
            }
            return claimCopy
        }
        let request = MeeConsentRequest(claims: dataClearedFromDisabledOptionals, clientMetadata: data.clientMetadata, nonce: data.nonce, clientId: data.clientId, redirectUri: data.redirectUri, presentationDefinition: data.presentationDefinition, isCrossDevice: data.isCrossDeviceFlow, sdkVersion: data.sdkVersion)
        return request
    }
    
    
}
