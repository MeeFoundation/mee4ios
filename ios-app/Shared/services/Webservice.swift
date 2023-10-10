//
//  Webservice.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 8.2.23..
//

import Foundation

@MainActor
class WebService {
    let baseUrl: String
    
    init() {
        let config = ConfigLoader.parseFile()
        baseUrl = config.proxyUrl
    }
    
    func passConsentOverRelay(id: String, data: String) async throws {
        guard let url = URL(string: "\(baseUrl)/put") else {
            throw NetworkError.badUrl
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let json: [String: String] = ["session_id": id,
                                   "oidc_response": data]
        let jsonData = try JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        print("jsonData: ", String(decoding: jsonData, as: UTF8.self))
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            print("bad response: ", response, String(decoding: data, as: UTF8.self))
            throw NetworkError.badResponse
        }
        print("good response: ", httpResponse)
        return
        
    }
}
