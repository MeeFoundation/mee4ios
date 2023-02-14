//
//  Context.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 23.1.23..
//

import Foundation

struct Context: Codable, Identifiable {
    var id: String
    let did: String
    var claims: [ConsentRequestClaim]
    let clientMetadata: PartnerMetadata
}
