//
//  PartnerDetailsState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 22.11.22..
//

import Foundation

enum ConsentEntriesType {
    case SiopClaims(value: [ConsentRequestClaim])
    case GapiEntries(value: ExternalContext)
}

struct PartnerDetailsState {
    var durationPopupId: UUID? = nil
    var consentEntries: ConsentEntriesType? = nil
    var isRequiredOpen: Bool = true
    var isOptionalOpen: Bool = false
    var selection: String? = nil
    var scrollPosition: UUID?
}
