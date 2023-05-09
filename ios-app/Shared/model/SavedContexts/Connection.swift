//
//  Context.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 23.1.23..
//

import Foundation

enum ConnectionTypeSubject {
    case DidKey(value: String)
    case JwkThumbprint(value: String)
}

struct SiopConnectionType {
    let redirectUri: String
    let clientMetadata: PartnerMetadata
    let subject: ConnectionTypeSubject
}

struct GapiConnectionType {
    let scopes: [String]
}

enum ConnectionType {
    case Siop(value: SiopConnectionType)
    case Gapi(value: GapiConnectionType)
    case MeeTalk
}

struct Connection: Identifiable {
    var id: String
    let name: String
    let value: ConnectionType
    
    init(id: String, name: String, value: ConnectionType) {
        self.id = id
        self.name = name
        self.value = value
    }
    
    init?(from: OtherPartyConnectionUniffi) {
        self.id = from.id
        self.name = from.name
        switch (from.protocol) {
        case .gapi(let gapiValue):
            self.value = .Gapi(value: GapiConnectionType(scopes: gapiValue.scopes))
        case .siop(let siopValue):
            guard let clientMetadata = PartnerMetadata(from: siopValue.clientMetadata) else {
                return nil
            }
            var subject: ConnectionTypeSubject
            switch (siopValue.subjectSyntaxType) {
            case .didKey(let value):
                subject = .DidKey(value: value)
            case .jwkThumbprint(let value):
                subject = .JwkThumbprint(value: value)
            }
            self.value = .Siop(value: SiopConnectionType(redirectUri: siopValue.redirectUri, clientMetadata: clientMetadata, subject: subject))
        case .meeTalk:
            self.value = .MeeTalk
        }
    }
}
