//
//  MeeResponse.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 22.12.22..
//

import Foundation

struct MeeResponseEntry: Encodable {
    var field_type: ConsentEntryType
    var value: String
    var duration: ConsentStorageDuration
}
