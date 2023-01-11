//
//  ConsentState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 10.03.2022.
//

import Foundation

struct ConsentModel {
    var id: String {
        return client_id
    }
    let client_id: String
    let name: String
    let acceptUrl: String
    let rejectUrl: String
    let displayUrl: String
    let logoUrl: String
    let isMobileApp: Bool
    let isMeeCertified: Bool
    var entries: [ConsentEntryModel] = []
}

let emptyConsentModel = ConsentModel(
    client_id: "", name: "", acceptUrl: "", rejectUrl: "", displayUrl: "", logoUrl: "", isMobileApp: false, isMeeCertified: false, entries: []
)

class ConsentState: ObservableObject {
    @Published var consent = emptyConsentModel
}
