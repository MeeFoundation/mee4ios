//
//  PartnerData.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 3.10.22..
//

import Foundation

struct PartnerData: Codable, Identifiable {
    var id: String {
        return client_id
    }
    let client_id: String
    let name: String
    let acceptUrl: String
    let rejectUrl: String
    let displayUrl: String
    let logoUrl: String
    let isMobileApp: Bool
    let isMeeCertified: Bool
}
