//
//  PartnerDetailsState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 22.11.22..
//

import Foundation

enum ConsentEntriesType {
    case SiopClaims(value: [ConsentRequestClaim])
    case ExternalEntries(value: MeeExternalContextWrapper)
}

