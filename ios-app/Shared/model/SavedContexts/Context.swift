//
//  Context.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 3.5.23..
//

struct Context {
    let id: String
    let otherPartyConnectionId: String
    let createdAt: String
    let attributes: [ConsentRequestClaim]
    
    init(from: SiopConsentUniffi) {
        self.id = from.id
        self.otherPartyConnectionId = from.otherPartyConnectionId
        self.createdAt = from.createdAt
        let claimDataConverted = from.attributes.reduce([]) { (acc: [ConsentRequestClaim], rec) in
            var copy = acc
            if let value = rec.value,
               let request = ConsentRequestClaim(from: value, code: rec.key)
            {
                copy.append(request)
            }
            return copy
        }
        self.attributes = claimDataConverted
    }
}
