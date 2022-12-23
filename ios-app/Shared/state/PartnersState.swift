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
            PartnerData(
                client_id: "nyt",
                name: "The New York Times",
                acceptUrl: "https://demo-dev.mee.foundation",
                rejectUrl: "https://demo-dev.mee.foundation",
                displayUrl: "nytimes.com",
                logoUrl: "https://theme.zdassets.com/theme_assets/968999/d8a347b41db1ddee634e2d67d08798c102ef09ac.jpg",
                isMobileApp: false,
                isMeeCertified: true
            ),
            PartnerData(
                client_id: "nytcompatible",
                name: "The New York Times",
                acceptUrl: "https://demo-dev.mee.foundation",
                rejectUrl: "https://demo-dev.mee.foundation",
                displayUrl: "nytimes.com",
                logoUrl: "https://theme.zdassets.com/theme_assets/968999/d8a347b41db1ddee634e2d67d08798c102ef09ac.jpg",
                isMobileApp: false,
                isMeeCertified: true
            ),
            PartnerData(
                client_id: "nytmobile",
                name: "The New York Times",
                acceptUrl: "https://demo-dev.mee.foundation",
                rejectUrl: "https://demo-dev.mee.foundation",
                displayUrl: "nytimes.com",
                logoUrl: "https://theme.zdassets.com/theme_assets/968999/d8a347b41db1ddee634e2d67d08798c102ef09ac.jpg",
                isMobileApp: true,
                isMeeCertified: true
            ),
            PartnerData(
                client_id: "twp",
                name: "The Washington Post",
                acceptUrl: "https://demo-dev.mee.foundation",
                rejectUrl: "https://demo-dev.mee.foundation",
                displayUrl: "washingtonpost.com",
                logoUrl: "https://www.washingtonpost.com/favicon.ico",
                isMobileApp: false,
                isMeeCertified: true
            ),
            PartnerData(
                client_id: "twpmobile",
                name: "The Washington Post",
                acceptUrl: "https://demo-dev.mee.foundation",
                rejectUrl: "https://demo-dev.mee.foundation",
                displayUrl: "washingtonpost.com",
                logoUrl: "https://www.washingtonpost.com/favicon.ico",
                isMobileApp: true,
                isMeeCertified: true
            ),
            PartnerData(
                client_id: "tg",
                name: "The Guardian",
                acceptUrl: "https://demo-dev.mee.foundation",
                rejectUrl: "https://demo-dev.mee.foundation",
                displayUrl: "theguardian.com",
                logoUrl: "https://theguardian.com/favicon.ico",
                isMobileApp: false,
                isMeeCertified: true
            ),
            PartnerData(
                client_id: "tgmobile",
                name: "The Guardian",
                acceptUrl: "https://demo-dev.mee.foundation",
                rejectUrl: "https://demo-dev.mee.foundation",
                displayUrl: "theguardian.com",
                logoUrl: "https://theguardian.com/favicon.ico",
                isMobileApp: true,
                isMeeCertified: true
            ),
            PartnerData(
                client_id: "wsj",
                name: "The Wall Street Journal",
                acceptUrl: "https://demo-dev.mee.foundation",
                rejectUrl: "https://demo-dev.mee.foundation",
                displayUrl: "wsj.com",
                logoUrl: "https://wsj.com/favicon.ico",
                isMobileApp: false,
                isMeeCertified: true
            )
        ]
    }
}
