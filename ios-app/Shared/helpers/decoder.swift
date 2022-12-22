//
//  decoder.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 22.12.22..
//

import Foundation

func decodeString(_ data: String) -> Data? {
    guard let jsonString = data.fromBase64() else {
        return nil
    }
    guard let data = jsonString.data(using: .utf8) else {
        return nil
    }
    return data
}
