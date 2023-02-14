//
//  Webservice.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 8.2.23..
//

import Foundation
struct RelayResponse: Codable {
    let code: String
}

class Webservice {
    func test() async -> RelayResponse? {
        do {
            guard let url = URL(string: "") else {
                return nil
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            return try? JSONDecoder().decode(RelayResponse.self, from:data)
        } catch {
            return nil
        }
    }
}
