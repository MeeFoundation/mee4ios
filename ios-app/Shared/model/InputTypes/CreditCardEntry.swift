//
//  CreditCardType.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 23.3.23..
//

import Foundation

struct CreditCardEntry: Codable {
    var number: String?
    var expirationDate: String?
    var cvc: String?
}
