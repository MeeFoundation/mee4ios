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
        [ConsentEntryModel(name: "Private Personal Identifier", type: ConsentEntryType.id, value:"did:key:z6MkjBWPPa1njEKygyr3LR3pRKkqv714vyTkfnUdP6ToF", isRequired: true, canRead: true),
         ConsentEntryModel(name: "Email", type: ConsentEntryType.email, value: nil, isRequired: true, canRead: true, canWrite: true),
         ConsentEntryModel(name: "First Name", type: ConsentEntryType.name, value: nil, isRequired: false, canRead: true, canWrite: true),
         ConsentEntryModel(name: "Date of Birth", type: ConsentEntryType.date, value: nil, isRequired: false, canRead: true, canWrite: true)]
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
            isMeeCertified: true
        ),
        PartnersModel(
            id: "twp",
            name: "The Washington Post",
            url: "https://demo-dev.meeproject.org",
            displayUrl: "washingtonpost.com",
            imageUrl: "https://www.washingtonpost.com/favicon.ico",
            isMeeCertified: true

        ),
        PartnersModel(
            id: "tg",
            name: "The Guardian",
            url: "https://demo-dev.meeproject.org",
            displayUrl: "theguardian.com",
            imageUrl: "https://theguardian.com/favicon.ico",
            isMeeCertified: false
        ),
        PartnersModel(
            id: "wsj",
            name: "The Wall Street Journal",
            url: "https://demo-dev.meeproject.org/",
            displayUrl: "wsj.com",
            imageUrl: "https://wsj.com/favicon.ico",
            isMeeCertified: false
        )
    ]
}

