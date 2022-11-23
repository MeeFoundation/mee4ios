//
//  PartnersState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import Foundation

class PartnersState: ObservableObject {
    private let keychain = KeyChainConsents()
    @Published var partners: [PartnersModel]
    var consents: [PartnersModel] {
        return partners.filter{ partner in
            !partner.isMobileApp && keychain.getItemByName(name: partner.id) != nil
        }
    }
    
    init() {
        self.partners = [
            PartnersModel(
                id: "nyt",
                name: "The New York Times",
                url: "https://demo-dev.meeproject.org",
                displayUrl: "nytimes.com",
                imageUrl: "https://theme.zdassets.com/theme_assets/968999/d8a347b41db1ddee634e2d67d08798c102ef09ac.jpg",
                isMeeCertified: true,
                isMobileApp: false
            ),
            PartnersModel(
                id: "nytcompatible",
                name: "The New York Times",
                url: "https://demo-dev.meeproject.org",
                displayUrl: "nytimes.com",
                imageUrl: "https://theme.zdassets.com/theme_assets/968999/d8a347b41db1ddee634e2d67d08798c102ef09ac.jpg",
                isMeeCertified: false,
                isMobileApp: false
            ),
            PartnersModel(
                id: "nytmobile",
                name: "The New York Times",
                url: "https://demo-dev.meeproject.org",
                displayUrl: "nytimes.com",
                imageUrl: "https://theme.zdassets.com/theme_assets/968999/d8a347b41db1ddee634e2d67d08798c102ef09ac.jpg",
                isMeeCertified: true,
                isMobileApp: true
            ),
            PartnersModel(
                id: "twp",
                name: "The Washington Post",
                url: "https://demo-dev.meeproject.org",
                displayUrl: "washingtonpost.com",
                imageUrl: "https://www.washingtonpost.com/favicon.ico",
                isMeeCertified: true,
                isMobileApp: false
            ),
            PartnersModel(
                id: "twpmobile",
                name: "The Washington Post",
                url: "https://demo-dev.meeproject.org",
                displayUrl: "washingtonpost.com",
                imageUrl: "https://www.washingtonpost.com/favicon.ico",
                isMeeCertified: true,
                isMobileApp: true
            ),
            PartnersModel(
                id: "tg",
                name: "The Guardian",
                url: "https://demo-dev.meeproject.org",
                displayUrl: "theguardian.com",
                imageUrl: "https://theguardian.com/favicon.ico",
                isMeeCertified: false,
                isMobileApp: false
            ),
            PartnersModel(
                id: "tgmobile",
                name: "The Guardian",
                url: "https://demo-dev.meeproject.org",
                displayUrl: "theguardian.com",
                imageUrl: "https://theguardian.com/favicon.ico",
                isMeeCertified: false,
                isMobileApp: true
            ),
            PartnersModel(
                id: "wsj",
                name: "The Wall Street Journal",
                url: "https://demo-dev.meeproject.org",
                displayUrl: "wsj.com",
                imageUrl: "https://wsj.com/favicon.ico",
                isMeeCertified: false,
                isMobileApp: false
            )
        ]
    }
}
