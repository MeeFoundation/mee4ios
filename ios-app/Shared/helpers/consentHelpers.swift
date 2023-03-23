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

func isCardEntryValid(_ entry: CreditCardEntry) -> Bool {
    if let number = entry.number,
       let exp = entry.expirationDate,
       let cvc = entry.cvc {
        return !number.isEmpty || !exp.isEmpty || !cvc.isEmpty
    }
    return false
}
