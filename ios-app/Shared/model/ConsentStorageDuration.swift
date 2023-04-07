//
//  ConsentStorageDuration.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 22.12.22..
//

import Foundation

enum ConsentStorageDuration: String, Codable {
    case whileUsingApp = "while_using_app"
    case untilConnectionDeletion = "until_connection_deletion"
}
