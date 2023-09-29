//
//  ConsentsList.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 22.11.22..
//

enum WelcomeType {
    case NONE
    case FIRST
    case SECOND
}

struct ConsentsListState {
    var selection: String? = nil
    var existingPartnersWebApp: [MeeConnectorWrapper]?
    var otherPartnersWebApp: [MeeConnectorWrapper]?
    var existingPartnersMobileApp: [MeeConnectorWrapper]?
    var otherPartnersMobileApp: [MeeConnectorWrapper]?
    var showCertifiedOrCompatible: CertifiedOrCompatible? = nil
    var showCompatibleWarning: Bool = false
    var showIntroScreensSwitch: Bool = false
}
