//
//  ConsentEntryType.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 22.12.22..
//

import Foundation

enum ConsentEntryType: String, Codable {
    case string = "string"
    case date = "date"
    case boolean = "boolean"
    case email = "email"
    case address = "address"
    case card = "card"
    case ageProtect = "ageProtect"
}
