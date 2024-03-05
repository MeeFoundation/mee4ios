//
//  CoreAgent.swift
//  mee-extension
//
//  Created by Anthony Ivanov on 7.11.23..
//

import Foundation

protocol CoreAgent {
    func getAllConnectors() async -> [MeeConnectorWrapper]
    func removeAllData() async throws
    func removeConnector(connector: MeeConnectorWrapper) async throws
    func getConnectorById(id: String) async -> MeeConnectorWrapper?
    func checkSiopConnectionExists (id: String) async -> Bool
    func getLastSiopConsentByRedirectUri (id: String) async -> MeeContextWrapper?
    func getLastConsentByConnectorId(id: String) async -> MeeContextWrapper?
    func authorize(id: String, item: MeeConsentRequest) async -> OidcAuthResponseWrapper?
    func getGoogleIntegrationUrl() async -> URL?
    func createGoogleConnectionAsync(url: URL) async throws
    func createExtensionConnectionAsync (url: String, gpcEnabled: Bool) async throws
    func authAuthRequestFromUrl (url: String, isCrossDevice: Bool, sdkVersion: SdkVersion) async -> MeeConsentRequest?
}
