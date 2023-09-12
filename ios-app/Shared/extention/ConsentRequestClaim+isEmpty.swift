//
//  ConsentEntryValue.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 28.4.23..
//

import Foundation

extension ConsentRequestClaim {
    var isEmpty: Bool {
        switch self.value {
        case .card(let entry):
            return entry.cvc == nil || entry.expirationDate == nil || entry.number == nil
        case .ageProtect(let entry):
            return entry.age == nil || entry.dateOfBirth == nil || entry.jurisdiction == nil
        case.string(let entry):
            return entry == nil
        case nil:
            return true
        }
   
    }
}
