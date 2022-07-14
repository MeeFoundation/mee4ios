//
//  ConsentState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 10.03.2022.
//

import Foundation

class ConsentState: ObservableObject {
    @Published var consent = ConsentModel(name: "The New York Times", url: "nytimes.com", entries:
                                            [ConsentEntryModel(name: "Private Personal Identifier", type: ConsentEntryType.id, isRequired: true, canRead: true),
                                             ConsentEntryModel(name: "First Name", type: ConsentEntryType.name, isRequired: true, canRead: true),
                                             ConsentEntryModel(name: "Email", type: ConsentEntryType.email, isRequired: true, canRead: true),
                                             ConsentEntryModel(name: "Credit Card", type: ConsentEntryType.card, canRead: true),
                                             ConsentEntryModel(name: "Date of Birth", type: ConsentEntryType.date, canRead: true, canWrite: true, hasValue: false)])
}

