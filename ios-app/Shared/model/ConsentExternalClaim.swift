//
//  ExternalConsentEntry.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 16.11.23..
//

import Foundation

struct ConsentExternalClaim: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.id != rhs.id { return false }
        if let leftStringValue = lhs.value as? String, let rightStringValue = rhs.value as? String {
            return leftStringValue == rightStringValue
        }
        if let leftStringValue = lhs.value as? Bool, let rightStringValue = rhs.value as? Bool {
            return leftStringValue == rightStringValue
        }
        return false
    }
    
    var id: String
    var name: String
    var value: Any
}
