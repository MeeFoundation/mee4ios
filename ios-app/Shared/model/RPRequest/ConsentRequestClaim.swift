//
//  ConsentItemModel.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.02.2022.
//

import Foundation
import SwiftUI

enum ConsentEntryValue: Codable {
    case string(String?)
    case card(CreditCardEntry)
    case ageProtect(AgeProtectCardEntry)
}

struct ConsentRequestClaim: Identifiable, Codable {
    let id = UUID()
    var code: String
    var name: String
    var attributeType: String?
    var businessPurpose: String?
    var isSensitive: Bool?
    var type: ConsentEntryType
    var value: ConsentEntryValue?
    var providedBy: String?
    var retentionDuration: ConsentStorageDuration = .untilConnectionDeletion
    var isRequired: Bool = false
    var isOn: Bool = false
    var forceOpen: Bool?
    var isOpen: Bool {
        get {
            if type == .ageProtect {
                return true
            }
            if let forceOpen {
                return forceOpen
            } else {

                return false
            }
            
        }
        set(newValue) {
            forceOpen = self.isIncorrect ? true : newValue
        }
    }
    var isIncorrect: Bool {
        if case .string(let stringValue) = value {
            return (isRequired || isOn) && (stringValue == nil || stringValue!.isEmpty)
        }
        if case .card(let cardValue) = value {
            return (isRequired || isOn) && (!cardValue.isValid())
        }
        if case .ageProtect(let ageProtectValue) = value {
            return (isRequired || isOn) && (!ageProtectValue.isValid())
        }
        return true
    }
    private enum CodingKeys: String, CodingKey {
        case code, name, value, isRequired, providedBy, type, retentionDuration
    }
    init(code: String, name: String, type: ConsentEntryType, value: String?, providedBy: String?, isRequired: Bool? = false, isOn: Bool? = false) {
        self.code = code
        self.name = name
        self.type = type
        self.value = type == .card ? .card(CreditCardEntry.fromString(value)) : type == .ageProtect ? .ageProtect(AgeProtectCardEntry.fromString(value)) : .string(value)
        self.providedBy = providedBy
        self.isRequired = isRequired ?? false
        self.isOn = isOn ?? false
    }
    init?(from: OidcClaimParams, code: String) {
        guard
                let name = from.name,
                let type = ConsentEntryType(rawValue: from.typ ?? "")
        else {
            return nil
        }
        self.name = name
        self.type = type
        self.value = type == .card ? .card(CreditCardEntry.fromString(from.value)) : type == .ageProtect ? .ageProtect(.fromString(from.value)) : .string(from.value)
        self.providedBy = nil
        self.isRequired = from.essential
        self.isOn = from.essential
        self.retentionDuration = from.retentionDuration == .whileUsingApp ? .whileUsingApp : .untilConnectionDeletion
        self.attributeType = from.attributeType
        self.businessPurpose = from.businessPurpose
        self.isSensitive = from.isSensitive
        self.code = code
    }
}
