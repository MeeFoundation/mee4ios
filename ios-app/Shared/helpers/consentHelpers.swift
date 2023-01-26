//
//  consentHelpers.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 22.12.22..
//

import Foundation

func getConsentEntryImageByType (_ entryType: ConsentEntryType, isDisabled: Bool = false) -> String {
    switch entryType {
    case ConsentEntryType.string:
        return "personIcon"
    case ConsentEntryType.email:
        return "letterIcon"
    case ConsentEntryType.card:
        return "cardIcon"
    case ConsentEntryType.date:
        return "calendarIcon"
    default:
        return "keyIcon"
    }
}

func makeMeeResponse(_ data: [ConsentRequestClaim]) -> [String: MeeResponseEntry] {
    var response: [String: MeeResponseEntry] = [:]
    data.forEach { entry in
        guard let value = entry.value else {
            return
        }
        let one = MeeResponseEntry(
            field_type: entry.type,
            value: value,
            duration: entry.retentionDuration)
        response[entry.name] = one
    }
    return response
}
