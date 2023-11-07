//
//  CoreAgent.swift
//  mee-extension
//
//  Created by Anthony Ivanov on 7.11.23..
//

import Foundation

protocol CoreAgent {
    func getAllConnectors() async -> [MeeConnectorWrapper]
    func getLastConsentByConnectorId(id: String) async -> MeeContextWrapper?
    func getLastSiopConsentByConnectionId(id: String) async -> MeeContextWrapper?
    func authorize(id: String, item: MeeConsentRequest) async -> OidcAuthResponseWrapper?
    func removeConnector(connector: MeeConnectorWrapper) async -> String?
    func removeAllData() async -> Bool
}
