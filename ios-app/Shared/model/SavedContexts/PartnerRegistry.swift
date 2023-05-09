//
//  PartnerRegistry.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 23.1.23..
//

import Foundation

//
//  PartnerData.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 3.10.22..
//

import Foundation

struct PartnerRegistryEntry: Identifiable {
    var id: String
    let clientMetadata: PartnerMetadata
}
