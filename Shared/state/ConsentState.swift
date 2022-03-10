//
//  ConsentState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 10.03.2022.
//

import Foundation

class ConsentState: ObservableObject {
    @Published var consent = ConsentModel(name: "Eat Naked Kitchen",entries:
                                            [ConsentEntryModel(name: "First Name", isRequired: true, canRead: true),
                                            ConsentEntryModel(name: "Email", isRequired: true, canRead: true),
                                            ConsentEntryModel(name: "Date Of Birth", canRead: true),
                                            ConsentEntryModel(name: "Mee Orders", canRead: true, canWrite: true, hasValue: false)], scopes: ["OpenId", "Email", "First Name"])
}
