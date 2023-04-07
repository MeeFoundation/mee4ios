//
//  CreditCardType.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 23.3.23..
//

import Foundation

struct CreditCardEntry: Codable {
    var number: String? {
        didSet {
            if let newNumber = number {
                if !matchesRegex(regex: #"^[0-9]{0,16}$"#, text: newNumber) {
                    number = oldValue
                }
            }
            
        }
    }
    var expirationDate: String? {
        didSet {
            if let newNumber = expirationDate {
                if !matchesRegex(regex: #"^[0-9\/\\]{0,7}$"#, text: newNumber) {
                    expirationDate = oldValue
                }
            }
            
        }
    }
    var cvc: String? {
        didSet {
            if let newNumber = cvc {
                if !matchesRegex(regex: #"^[0-9]{0,5}$"#, text: newNumber) {
                    cvc = oldValue
                }
            }
            
        }
    }
    
    func toString() -> String? {
        let jsonEncoder = JSONEncoder()
        do {
            return try String(data: jsonEncoder.encode(self), encoding: .utf8)
        } catch {
            return nil
        }
        
    }
    
    static func fromString(_ string: String?) -> Self {
        do {
            let jsonDecoder = JSONDecoder()
            if let data = string?.data(using: .utf8) {
                return try jsonDecoder.decode(CreditCardEntry.self, from: data)
            }
            return Self()
        } catch {
            return Self()
        }
        
    }
}
