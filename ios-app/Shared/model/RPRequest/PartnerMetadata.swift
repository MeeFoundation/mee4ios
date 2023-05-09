//
//  PartnerData.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 3.10.22..
//

import Foundation

struct PartnerMetadata: Identifiable {
    var id: String {
        return name
    }
    let name: String
    let displayUrl: String
    let logoUrl: String
    let type: ClientType
    let jwks: [String]?
    let idTokenSignedResponseAlg: String?
    let idTokenEncryptedResponseAlg: String?
    let idTokenEncryptedResponseEnc: String?
    let subjectSyntaxTypesSupported: [SubjectSyntaxTypesSupported]
    var isMobileApp: Bool {
        return type == .mobile
    }
    var contacts: [String]?
    
    init(name: String,
         displayUrl: String,
         logoUrl: String,
         contacts: [String]
    ) {
        self.name = name
        self.displayUrl = displayUrl
        self.logoUrl = logoUrl
        self.type = .web
        self.contacts = contacts
        self.jwks = nil
        self.subjectSyntaxTypesSupported = []
        self.idTokenSignedResponseAlg = nil
        self.idTokenEncryptedResponseAlg = nil
        self.idTokenEncryptedResponseEnc = nil
    }
    
    
    init?(from: OidcClientMetadata) {
        guard
            let clientName = from.clientName,
            let logoUro = from.logoUri,
            let applicationType = from.applicationType,
            let clientType = ClientType(rawValue: applicationType) else {
                return nil
            }
        self.name = clientName
        self.displayUrl = clientName
        self.logoUrl = logoUro
        self.type = clientType
        self.contacts = from.contacts
        self.jwks = from.jwks
        self.subjectSyntaxTypesSupported = from.subjectSyntaxTypesSupported
        self.idTokenSignedResponseAlg = from.idTokenSignedResponseAlg
        self.idTokenEncryptedResponseAlg = from.idTokenEncryptedResponseAlg
        self.idTokenEncryptedResponseEnc = from.idTokenEncryptedResponseEnc
    }
}
