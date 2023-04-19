//
//  Webservice.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 8.2.23..
//

import Foundation

@MainActor
class WebService {
    func passConsentOverRelay(data: String) async throws {
        
        guard let url = URL(string: "https://mee.foundation/proxy") else {
            throw NetworkError.badUrl
        }
        let (_, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        return
        
    }
}
