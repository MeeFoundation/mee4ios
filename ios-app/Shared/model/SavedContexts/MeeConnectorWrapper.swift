//
//  MeeConnectorWrapper.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 28.9.23..
//

import Foundation

enum ConnectorProtocolSubject {
    case DidKey(value: String)
    case JwkThumbprint(value: String)
}

struct SiopConnectorProtocol {
    let redirectUri: String
    let clientMetadata: PartnerMetadata
    let subject: ConnectorProtocolSubject
}

struct GapiConnectorProtocol {
    let scopes: [String]
}

struct OpenIdConnectorProtocol {
    let issuerUrl: String
}

enum MeeConnectorWrapperProtocol {
    case Siop(value: SiopConnectorProtocol)
    case Gapi(value: GapiConnectorProtocol)
    case openId4Vc(value: OpenIdConnectorProtocol)
    case MeeTalk
    case MeeBrowserExtension
}


struct MeeConnectorWrapper: Identifiable, Equatable {
    static func == (lhs: MeeConnectorWrapper, rhs: MeeConnectorWrapper) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String
    let name: String
    let otherPartyConnectionId: String
    let connectorProtocol: MeeConnectorWrapperProtocol
    
    init(id: String, name: String, otherPartyConnectionId: String, connectorProtocol: MeeConnectorWrapperProtocol) {
        self.id = id
        self.name = name
        self.otherPartyConnectionId = otherPartyConnectionId
        self.connectorProtocol = connectorProtocol
    }
    
    var isGapi: Bool {
        switch(self.connectorProtocol) {
        case .Gapi(_):
            return true
        default: return false
        }
    }
    
    init?(from: OtherPartyConnectorUniffi) {
        self.id = from.id
        self.name = from.name
        self.otherPartyConnectionId = from.otherPartyConnectionId
        switch (from.protocol) {
        case .gapi(let gapiValue):
            self.connectorProtocol = .Gapi(value: GapiConnectorProtocol(scopes: gapiValue.scopes))
        case .siop(let siopValue):
            guard let clientMetadata = PartnerMetadata(from: siopValue.clientMetadata) else {
                return nil
            }
            var subject: ConnectorProtocolSubject
            switch (siopValue.subjectSyntaxType) {
            case .didKey(let value):
                subject = .DidKey(value: value)
            case .jwkThumbprint(let value):
                subject = .JwkThumbprint(value: value)
            }
            self.connectorProtocol = .Siop(value: SiopConnectorProtocol(redirectUri: siopValue.redirectUri, clientMetadata: clientMetadata, subject: subject))
            
        case .openId4Vc(value: let value):
            self.connectorProtocol = .openId4Vc(value: OpenIdConnectorProtocol(issuerUrl: value.issuerUrl))
        case .meeBrowserExtension:
            self.connectorProtocol = .MeeBrowserExtension
        case .meeTalk:
            self.connectorProtocol = .MeeTalk
        }
    }
}
