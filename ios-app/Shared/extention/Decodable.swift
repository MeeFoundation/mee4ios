//
//  Decodable.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 26.10.23..
//

import Foundation

extension Decodable {
    static func fromString(_ string: String?) -> Self? {
        do {
            let jsonDecoder = JSONDecoder()
            if let data = string?.data(using: .utf8) {
                return try jsonDecoder.decode(self.self, from: data)
            }
            return nil
        } catch {
            return nil
        }
    }
}
