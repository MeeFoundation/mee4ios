//
//  CreditCardEntry.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 30.3.23..
//

import Foundation

let creditCardNumberRegexp = #"^[0-9]{10,16}$"#
let creditCardExpRegexp = #"^[0-9]{1,2}[\/\\]{1,1}[0-9]{2,4}$"#
let creditCardCvcRegexp = #"^[0-9]{3,5}$"#

extension CreditCardEntry {
    
    func isValid() -> Bool {
        if let number = self.number,
           let exp = self.expirationDate,
           let cvc = self.cvc {
            let cardNumberIsValid = matchesRegex(regex: creditCardNumberRegexp, text: number)
            let cardExpIsValid = matchesRegex(regex: creditCardExpRegexp, text: exp)
            let cardCvcIsValid = matchesRegex(regex: creditCardCvcRegexp, text: cvc)
            return !(number.isEmpty || exp.isEmpty || cvc.isEmpty || !cardNumberIsValid || !cardExpIsValid || !cardCvcIsValid)
        }
        return false
    }
}
