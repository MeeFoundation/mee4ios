//
//  AgeProtectCardEntry.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 10.8.23..
//

import Foundation

struct AgeProtectCardEntry: Codable {
    var jurisdiction: String?
    var dateOfBirth: String?
    var age: String?
    
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
                return try jsonDecoder.decode(AgeProtectCardEntry.self, from: data)
            }
            return Self()
        } catch {
            return Self()
        }
        
    }
    
    func isValid() -> Bool {
        if let jurisdiction = self.jurisdiction,
           let dateOfBirth = self.dateOfBirth,
           let age = self.age {
            return !(jurisdiction.isEmpty || dateOfBirth.isEmpty || age.isEmpty)
        }
        return false
    }
}
