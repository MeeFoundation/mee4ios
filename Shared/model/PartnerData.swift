//
//  PartnerData.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 3.10.22..
//

import Foundation

struct PartnerData: Decodable {
    let partnerId: String
    let partnerName: String
    let partnerUrl: String
    let partnerImageUrl: String
    let partnerDisplayedUrl: String
}
