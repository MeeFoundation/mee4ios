//
//  ConsentsList.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 22.11.22..
//

struct ConsentsListState {
    var selection: String? = nil
    var existingPartnersWebApp: [Context]?
    var otherPartnersWebApp: [Context]?
    var existingPartnersMobileApp: [Context]?
    var firstLaunch: Bool = true
    var otherPartnersMobileApp: [Context]?
    var showWelcome: Bool?
    var showCertifiedOrCompatible: CertifiedOrCompatible? = nil
    var showCompatibleWarning: Bool = false
}
