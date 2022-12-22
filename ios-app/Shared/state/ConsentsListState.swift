//
//  ConsentsList.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 22.11.22..
//

struct ConsentsListState {
    var selection: String? = nil
    var existingPartnersWebApp: [PartnerData]?
    var otherPartnersWebApp: [PartnerData]?
    var existingPartnersMobileApp: [PartnerData]?
    var firstLaunch: Bool = true
    var otherPartnersMobileApp: [PartnerData]?
    var showWelcome: Bool?
    var showCertifiedOrCompatible: CertifiedOrCompatible? = nil
    var showCompatibleWarning: Bool = false
}
