//
//  ConsentEntryType.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 22.12.22..
//

import Foundation

enum ConsentEntryType: String, Codable {
    case id = "id"
    case name = "name"
    case email = "email"
    case card = "card"
    case date = "date"
    case agreement = "agreement"
}
