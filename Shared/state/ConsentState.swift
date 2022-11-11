//
//  ConsentState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 10.03.2022.
//

import Foundation

let demoConsentModel = ConsentModel(
    id: "",
    name: "",
    url: "",
    imageUrl: "",
    displayUrl: "",
    entries:
        [ConsentEntryModel(name: "Private Personal Identifier", type: ConsentEntryType.id, value:"did:keri:EXq5YqaL6L48pf0fu7IUhL0JRaU2_RxFP0AL43wYn148", providedBy: nil, isRequired: true, canRead: true),
         ConsentEntryModel(name: "Email", type: ConsentEntryType.email, value: "paul@meeproject.org", providedBy: "LinkedIn", isRequired: true, canRead: true, canWrite: true),
         ConsentEntryModel(name: "Is over 13 years of age", type: ConsentEntryType.agreement, value: "true", providedBy: "PRIVO", isRequired: true, canRead: false, canWrite: false, hasValue: false),
         ConsentEntryModel(name: "First Name", type: ConsentEntryType.name, value: nil, providedBy: nil, isRequired: false, canRead: true, canWrite: true)]
)

class ConsentState: ObservableObject {
    @Published var consent = demoConsentModel
}

class PartnersState: ObservableObject {
    @Published var partners = [
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

