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
    case ConsentEntryType.ageProtect:
        return "personIcon"
    case ConsentEntryType.date:
        return "calendarIcon"
    default:
        return "keyIcon"
    }
}


