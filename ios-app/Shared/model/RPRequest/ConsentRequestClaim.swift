//
//  ConsentItemModel.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.02.2022.
//

import Foundation

struct ConsentRequestClaim: Identifiable, Codable {
    let id = UUID()
    var code: String
    var name: String
    var attributeType: String?
    var businessPurpose: String?
    var isSensitive: Bool?
    var type: ConsentEntryType
    var value: String?
    var providedBy: String?
    var retentionDuration: ConsentStorageDuration = .untilConnectionDeletion
    var isRequired: Bool = false
    var isOn: Bool = false
    var forceOpen: Bool?
    var isOpen: Bool {
        get {
            if let forceOpen {
                return forceOpen
            } else {
                if let value {
                    return isRequired && (value.isEmpty)
                }
            }
            return false
        }
        set(newValue) {
            forceOpen = newValue
        }
    }
    var isIncorrect: Bool {
        return (isRequired || isOn) && (value == nil || value!.isEmpty)
    }
    private enum CodingKeys: String, CodingKey {
        case code, name, value, isRequired, providedBy, type, retentionDuration
    }
    init(code: String, name: String, type: ConsentEntryType, value: String?, providedBy: String?, isRequired: Bool? = false, isOn: Bool? = false) {
        self.code = code
        self.name = name
        self.type = type
        self.value = value
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
        self.value = from.value
        self.providedBy = nil
        self.isRequired = from.essential
        self.isOn = from.essential
        self.retentionDuration = from.retentionDuration == .ephemeral ? .ephemeral : from.retentionDuration == .whileUsingApp ? .whileUsingApp : .untilConnectionDeletion
        self.attributeType = from.attributeType
        self.businessPurpose = from.businessPurpose
        self.isSensitive = from.isSensitive
        self.code = code
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let name = try container.decodeIfPresent(String.self, forKey: .name) {
            self.name = name
        } else {
            self.name = ""
        }
        if let value = try container.decodeIfPresent(String.self, forKey: .value) {
            self.value = value
        }
        
        if let type = try container.decodeIfPresent(ConsentEntryType.self, forKey: .type) {
            self.type = type
        } else {
            self.type = ConsentEntryType.string
        }
        
        if let providedBy = try container.decodeIfPresent(String.self, forKey: .providedBy) {
            self.providedBy = providedBy
        } else {
            self.providedBy = nil
        }
        
        if let code = try container.decodeIfPresent(String.self, forKey: .code) {
            self.code = code
        } else {
            self.code = ""
        }
        
        if let retentionDuration = try container.decodeIfPresent(ConsentStorageDuration.self, forKey: .retentionDuration) {
            self.retentionDuration = retentionDuration
        } else {
            self.retentionDuration = ConsentStorageDuration.untilConnectionDeletion
        }
        
        if let isRequired = try container.decodeIfPresent(Bool.self, forKey: .isRequired) {
            self.isRequired = isRequired
            if !isRequired {
                self.isOn = true
            }
        }
    }
}
