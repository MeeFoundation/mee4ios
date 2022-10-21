//
//  ConsentItemModel.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.02.2022.
//

import Foundation

struct ConsentModel: Codable {
    var id: String
    var name: String
    var url: String
    var imageUrl: String
    var displayUrl: String
    var entries: [ConsentEntryModel]
}

struct PartnersModel: Identifiable {
    var id: String
    var name: String
    var url: String
    var displayUrl: String
    var imageUrl: String
    var isMeeCertified: Bool
}

enum ConsentEntryType: Encodable {
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

struct ConsentEntryModel: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: ConsentEntryType
    var value: String?
    var isRequired: Bool = false
    var canRead: Bool = false
    var canWrite: Bool = false
    var hasValue: Bool = true
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
        case name, value, isRequired
    }
    init(name: String, type: ConsentEntryType, value: String?, isRequired: Bool? = false, canRead: Bool? = false, canWrite: Bool? = false, hasValue: Bool? = true, isOn: Bool? = false) {
        self.name = name
        self.type = type
        self.value = value
        self.isRequired = isRequired ?? false
        self.canRead = canRead ?? false
        self.canWrite = canWrite ?? false
        self.hasValue = hasValue ?? true
        self.isOn = isOn ?? false
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
        switch name {
        case "Email":
            self.type = ConsentEntryType.email
        case "Private Personal Identifier":
            self.type = ConsentEntryType.id
        case "Date of Birth":
            self.type = ConsentEntryType.date
        default:
            self.type = ConsentEntryType.name
        }
        if let isRequired = try container.decodeIfPresent(Bool.self, forKey: .isRequired) {
            self.isRequired = isRequired
            if !isRequired {
                self.isOn = true
            }
        }
    }
}
