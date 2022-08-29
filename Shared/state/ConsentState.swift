//
//  ConsentState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 10.03.2022.
//

import Foundation

class ConsentState: ObservableObject {
    @Published var consent = ConsentModel(
        name: "The New York Times",
        url: "nytimes.com",
        entries:
            [ConsentEntryModel(name: "Private Personal Identifier", type: ConsentEntryType.id, value:"did:key:z6MkjBWPPa1njEKygyr3LR3pRKkqv714vyTkfnUdP6ToF", isRequired: true, canRead: true),
             ConsentEntryModel(name: "Email", type: ConsentEntryType.email, value: nil, isRequired: true, canRead: true, canWrite: true),
             ConsentEntryModel(name: "First Name", type: ConsentEntryType.name, value: nil, isRequired: false, canRead: true, canWrite: true),
             ConsentEntryModel(name: "Date of Birth", type: ConsentEntryType.date, value: nil, isRequired: false, canRead: true, canWrite: true)]
      )
}

