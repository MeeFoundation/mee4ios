//
//  passwordGenerator.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 23.03.2022.
//

import Foundation

func generatePassword(_ isSpecialSymbolsOn: Bool,_ isUppercaseLettersOn: Bool,_ isNumbersOn: Bool,_ length: Int) -> String {
    let specialSymbols = isSpecialSymbolsOn ? #"!@#$%^&*()=+{}\|/?,."# : ""
    let uppercaseLetters = isUppercaseLettersOn ? "ABCDEFGHIJKLMNOPQRSTUVWXYZ" : ""
    let lowercaseLetters = "abcdefghijklmnopqrstuvwxyz"
    let numbers = isNumbersOn ? "1234567890" : ""
    let passwordCharacters = "\(lowercaseLetters)\(uppercaseLetters)\(numbers)\(specialSymbols)"
    return String((0..<length).compactMap{ _ in passwordCharacters.randomElement() })
}
