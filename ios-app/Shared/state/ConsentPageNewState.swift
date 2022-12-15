//
//  ConsentPageNewState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 22.11.22..
//

import Foundation

struct ConsentPageNewState {
    var showCertified = false
    var partner: PartnersModel?
    var durationPopupId: UUID? = nil
    var isRequiredSectionOpened: Bool = true
    var isOptionalSectionOpened: Bool = false
    var scrollPosition: UUID? = nil
}
