//
//  ConsentState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 10.03.2022.
//

import Foundation


class ConsentState: ObservableObject {
    @Published var consent: ConsentRequest = emptyConsentRequest

}

let emptyConsentRequest = ConsentRequest(claims: [], clientMetadata: PartnerMetadata(name: "", displayUrl: "", logoUrl: "", contacts: []), nonce: "", clientId: "", redirectUri: "", presentationDefinition: "")
    

