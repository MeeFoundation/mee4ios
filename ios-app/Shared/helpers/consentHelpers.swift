//
//  consentHelpers.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 22.12.22..
//

import Foundation

func getConsentEntryImageByType (_ entryType: ConsentEntryType, isDisabled: Bool = false) -> String {
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
    case ConsentEntryType.agreement:
        return "calendarIcon"
    }
}

func makeMeeResponse(_ data: [ConsentEntryModel]) -> [String: MeeResponseEntry] {
    var response: [String: MeeResponseEntry] = [:]
    data.forEach { entry in
        guard let value = entry.value else {
            return
        }
        let one = MeeResponseEntry(
            field_type: entry.type,
            value: value,
            duration: entry.storageDuration)
        response[entry.name] = one
    }
    return response
}
