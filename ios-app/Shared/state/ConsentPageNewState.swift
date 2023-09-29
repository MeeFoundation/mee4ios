//
//  ConsentPageNewState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 22.11.22..
//

import SwiftUI

struct ConsentPageNewState {
    var showCertified = false
    var partner: PartnerMetadata?
    var durationPopupId: UUID? = nil
    var isRequiredSectionOpened: Bool = true
    var isOptionalSectionOpened: Bool = false
    var scrollPosition: UUID? = nil
    var previousButtomSafeArea: Double? = nil
    var isCertified: Bool = true
        
    func onDecline(_ request: MeeConsentRequest) -> URL? {
        keyboardEndEditing()
        
        if var urlComponents = URLComponents(string: request.redirectUri) {
            urlComponents.queryItems = [URLQueryItem(name: request.sdkVersion == .v1 ? "mee_auth_token" : "id_token", value: "error:user_cancelled,error_description:user%20declined%20the%20request")]
            if let url = urlComponents.url {
                return url
            }
            
        }
        return nil
    }
    
    mutating func incorrectClaimIndex(_ claims: [ConsentRequestClaim]) -> Int? {
        keyboardEndEditing()
        let hasIncorrectFields = claims.firstIndex(where: {$0.isIncorrect}) != nil;
        if (!hasIncorrectFields) {
            return nil
        } else {
            if let incorrectFieldIndex = claims.firstIndex(where: {$0.isIncorrect}) {
                if (claims[incorrectFieldIndex].isRequired) {
                    isRequiredSectionOpened = true
                } else {
                    isOptionalSectionOpened = true
                }
                scrollPosition = claims[incorrectFieldIndex].id
                return incorrectFieldIndex
            }
            return 0
        }
    }
}
