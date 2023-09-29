//
//  Context.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 23.1.23..
//

import Foundation

struct MeeConnectionWrapper: Identifiable, Equatable {
    static func == (lhs: MeeConnectionWrapper, rhs: MeeConnectionWrapper) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String
    let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init?(from: OtherPartyConnectionUniffi) {
        self.id = from.id
        self.name = from.name
        
    }
}
