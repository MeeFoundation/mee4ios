//
//  generateSecret.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 11.5.23..
//

import Foundation

func generateSecret(length: Int) -> String? {
    var keyData = Data(count: length)
       let result = keyData.withUnsafeMutableBytes {
           SecRandomCopyBytes(kSecRandomDefault, length, $0.baseAddress!)
       }
       if result == errSecSuccess {
           return keyData.base64EncodedString()
       } else {
           print("Problem generating random bytes")
           return nil
       }
}
