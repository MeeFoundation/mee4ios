//
//  ConsentItemModel.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.02.2022.
//

import Foundation

struct ConsentModel {
    let name: String
    let url: String
    var entries: [ConsentEntryModel]
}

enum ConsentEntryType {
    case id
    case name
    case email
    case card
    case date
}

func getConsentEntryImageByType (_ entryType: ConsentEntryType) -> String {
    switch entryType {
    case ConsentEntryType.id:
        return "keyIcon"
    case ConsentEntryType.name:
        return "personIcon"
    case ConsentEntryType.email:
        return "letterIcon"
    case ConsentEntryType.card:
        return "cardIcon"
    case ConsentEntryType.date:
        return "calendarIcon"
    }
}

struct ConsentEntryModel: Identifiable {
    let id = UUID()
    let name: String
    let type: ConsentEntryType
    var value: String?
    var isRequired: Bool = false
    var canRead: Bool = false
    var canWrite: Bool = false
    var hasValue: Bool = true
    var isOn: Bool = false
    var isIncorrect: Bool = false
}
