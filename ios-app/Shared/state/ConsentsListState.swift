//
//  ConsentsList.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 22.11.22..
//

struct ConsentsListState {
    var selection: String? = nil
    var existingPartnersWebApp: [PartnersModel]?
    var otherPartnersWebApp: [PartnersModel]?
    var existingPartnersMobileApp: [PartnersModel]?
    var firstLaunch: Bool = true
    var otherPartnersMobileApp: [PartnersModel]?
    var showWelcome: Bool?
    var showCertifiedOrCompatible: CertifiedOrCompatible? = nil
    var showCompatibleWarning: Bool = false
}
