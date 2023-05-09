//
//  ConsentConfiguration.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 14.12.22..
//

import Foundation

struct ConsentConfiguration {
    var client_id: String?
    var client: PartnerMetadata?
    var env: MeeEnv?
    var scope: String?
    var claim: [String: MeeClaimItem]?
}
