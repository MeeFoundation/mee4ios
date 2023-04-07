//
//  PartnerDetailsState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 22.11.22..
//

import Foundation

struct PartnerDetailsState {
    var durationPopupId: UUID? = nil
    var consentEntries: [ConsentRequestClaim] = []
    var isRequiredOpen: Bool = true
    var isOptionalOpen: Bool = false
    var selection: String? = nil
    var scrollPosition: UUID?
}
