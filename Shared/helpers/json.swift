//
//  json.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 3.10.22..
//

import Foundation

func encodeJson(_ data: Encodable) -> String {
    do {
        let jsonData = try JSONEncoder().encode(data)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
    catch {
        return ""
    }
}
