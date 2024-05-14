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
    let tags: [OtherPartyTagUniffi]
    
    init(id: String, name: String, tags: [OtherPartyTagUniffi]) {
        self.id = id
        self.name = name
        self.tags = tags
    }
    
    init?(from: OtherPartyConnectionUniffi) {
        self.id = from.id
        self.name = from.name
        self.tags = from.tags
        
    }
}
