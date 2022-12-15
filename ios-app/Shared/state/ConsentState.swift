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
         ConsentEntryModel(name: "Is at least 13 years old", type: ConsentEntryType.agreement, value: "true", providedBy: "PRIVO", isRequired: true, canRead: false, canWrite: false, hasValue: false),
         ConsentEntryModel(name: "First Name", type: ConsentEntryType.name, value: nil, providedBy: nil, isRequired: false, canRead: true, canWrite: true)]
)

class ConsentState: ObservableObject {
    @Published var consent = demoConsentModel
}





