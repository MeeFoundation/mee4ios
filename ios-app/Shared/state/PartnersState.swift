//
//  PartnersState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import Foundation

class CertifiedPartnersState: ObservableObject {
    static let shared = CertifiedPartnersState()
    private let keychain = MeeAgentStore()
    @Published var partners: [PartnerData]
    var consents: [PartnerData] {
        return partners.filter{ partner in
            !partner.isMobileApp && keychain.getItemByName(name: partner.client_id) != nil
        }
    }
    
    init() {
        self.partners = [

        ]
    }
}
