//
//  ConsentStorageDuration.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 22.12.22..
//

import Foundation

enum ConsentStorageDuration: String, Codable {
    case temporary = "temporary"
    case appLifetime = "appLifetime"
    case manualRemove = "manualRemove"
}
