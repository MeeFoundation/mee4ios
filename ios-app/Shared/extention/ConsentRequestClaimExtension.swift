//
//  ConsentRequestClaim.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 30.3.23..
//

import Foundation

extension ConsentRequestClaim {
    func getFieldName() -> String {
        switch self.value {
        case .card(let card):
            return card.number ?? self.name
        case .string(let string): return string ?? self.name
        default: return self.name
        }
    }
}

