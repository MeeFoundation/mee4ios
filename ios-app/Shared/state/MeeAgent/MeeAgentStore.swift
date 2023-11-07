//
//  keyChain.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.03.2022.


import Foundation

let MEE_KEYCHAIN_SECRET_NAME = "MEE_KEYCHAIN_SECRET_NAME"

protocol MeeAgentStoreListener {
    var id: UUID {get}
    func onUpdate()
}

protocol MeeAgentStoreErrorListener {
    var id: UUID {get}
    func onError(error: AppErrorRepresentation)
}

func getDbUrl() throws -> URL {
    let fm = FileManager.default
    let folderURL = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    let dbURL = folderURL.appendingPathComponent("mee.sqlite")
    if !fm.fileExists(atPath: dbURL.path) {
        fm.createFile(atPath: dbURL.path, contents: nil)
    }
    return dbURL
}

func getNewAgent() throws -> MeeAgent? {
    let storage = KeyChainStorage()
    var passcode: String? = storage.getItem(name: MEE_KEYCHAIN_SECRET_NAME)
    if passcode == nil {
        passcode = generateSecret(length: 30)
        storage.editItem(name: MEE_KEYCHAIN_SECRET_NAME, value: passcode!)
    }
    guard let passcode else {
        throw AppError.KeychainError
    }
    
    let dbUrl = try getDbUrl()
    print("passcode: ", passcode)
    let agent = try getAgent(config: MeeAgentConfig(dsUrl: dbUrl.path, grandPassword: passcode, dsEncryptionPassword: nil, didRegistryConfig: MeeAgentDidRegistryConfig.didKey))
    return agent

}

let extensionSharedDefaults = UserDefaults(suiteName: "group.extensionshare.foundation.mee.ios-client")

class MeeAgentStore: NSObject, ObservableObject, CoreAgent {
    private var agent: MeeAgent?
    var error: AppErrorRepresentation? = nil
    var listeners: [MeeAgentStoreListener] = []
    var errorListeners: [MeeAgentStoreErrorListener] = []
    
    private func onConnectionsListUpdated() {
        for listener in listeners {
            listener.onUpdate()
        }
    }
    
    private func onError(_ error: AppErrorRepresentation) {
        for listener in errorListeners {
            listener.onError(error: error)
        }
    }
    
    func addErrorListener(_ listener: MeeAgentStoreErrorListener) {
        errorListeners.append(listener)
    }
    
    func removeErrorListener(_ listener: MeeAgentStoreErrorListener) {
        errorListeners = errorListeners.filter { l in
            listener.id == l.id
        }
    }
    
    func addListener(_ listener: MeeAgentStoreListener) {
        listeners.append(listener)
    }
    
    func removeListener(_ listener: MeeAgentStoreListener) {
        listeners = listeners.filter { l in
            listener.id == l.id
        }
    }
    
    override init() {
        super.init()
        do {
            if let agent = try getNewAgent() {
                self.agent = agent
                try agent.initUserAccount()
                extensionSharedDefaults?.addObserver(self, forKeyPath: "meeExtensionQueue", options: .new, context: nil)
//                throw AppError.CoreError(MeeError.MeeStorage(error: .AppLevelMigration(error: "some error")))
            }
            
        } catch(let e) {
            print(e)
            error = AppErrorRepresentation(error: errorToAppError(e), action: .initialization)
            
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard keyPath == "meeExtensionQueue",
              let change = change,
              let meeExtensionQueue = change[.newKey] as? String else {
            return
        }
        
        if !meeExtensionQueue.isEmpty {
            getAllConnectors() { _ in }
        }
    }
    
    deinit {
        extensionSharedDefaults?.removeObserver(self, forKeyPath: "meeExtensionQueue")
    }
    
    func reinit() -> Bool {
        do {
            if let agent = try getNewAgent() {
                self.agent = agent
                try agent.initUserAccount()
//                throw AppError.CoreError(MeeError.MeeStorage(error: .Other(error: "some error")))
                return true
            } else {
                throw AppError.UnknownError
            }
            
        } catch(let e) {
            print(e)
            onError(AppErrorRepresentation(error: errorToAppError(e), action: .userDataRemoving))
            return false
        }
        
    }
        
    func removeAllData() async -> Bool {
        return await withCheckedContinuation { continuation in
            guard let agent else {
                continuation.resume(returning: false)
                return
            }
            do {
                try agent.deleteAllData()
                let result = reinit()
                continuation.resume(returning: result)
            } catch(let e) {
                print(e)
                continuation.resume(returning: false)
            }
        }
    }

    private func getAllConnections () async -> [MeeConnectionWrapper] {
        return await withCheckedContinuation { continuation in
            guard let agent else {
                continuation.resume(returning: [])
                return
            }
            do {
                let connectionsCore = try agent.otherPartyConnections();
                let connections = connectionsCore.reduce([]) { (acc: [MeeConnectionWrapper], connection) in
                    var copy = acc

                    if let connection = MeeConnectionWrapper(from: connection) {
                        copy.append(connection)
                    }
                    return copy
                }
                continuation.resume(returning: connections)
            } catch {
                print("error getting all contexts: \(error)")
                continuation.resume(returning: [])
            }
        }
    }
    
    private func getAllConnectionConnectors(connectionId: String) -> [MeeConnectorWrapper] {
        guard let agent else {
            return []
        }
        do {
            let connectorsCore = try agent.getOtherPartyConnectionConnectors(connId: connectionId);
            let connectors = connectorsCore.reduce([]) { (acc: [MeeConnectorWrapper], connector) in
                var copy = acc

                if let connector = MeeConnectorWrapper(from: connector) {
                    copy.append(connector)
                }
                return copy
            }

            return connectors
        } catch {
            print("error getting all contexts: \(error)")
            return []
        }
    }

    func getAllConnectionConnectors (connectionId: String) async -> [MeeConnectorWrapper] {
        return await withCheckedContinuation { continuation in
            let result = getAllConnectionConnectors(connectionId: connectionId)
            continuation.resume(returning: result)
        }
    }
    
    private func checkExtensionUpdates() {
        let userDefaultsQueue = extensionSharedDefaults?.string(forKey: MEE_EXTENSION_QUEUE)
        if let queue = [MeeExtenstionEntry].fromString(userDefaultsQueue) {
            for entry in queue {
                try? self.createExtensionConnection (url: entry.domain, gpcEnabled: entry.gpcEnabled)
            }
            extensionSharedDefaults?.set("", forKey: MEE_EXTENSION_QUEUE)
            print("queue: ", queue)
        }
    }
    
    private func clearExtensionCache() {
        print("clearExtensionCache")
        guard let extensionSharedDefaults else {
            return
        }
        let dictionary = extensionSharedDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key != MEE_EXTENSION_QUEUE {
                extensionSharedDefaults.removeObject(forKey: key)
            }
            
        }
    }
    
    private func updateExtensionCache(_ connectors: [MeeConnectorWrapper]) {
        print("updateExtensionCache")
        connectors.forEach { connector in
//            print("meebrext:", connector.otherPartyConnectionId, try? agent?.meeBrextGetSiteAttributes(siteHostname: connector.otherPartyConnectionId))
            if let attributes = try? agent?.meeBrextGetSiteAttributes(siteHostname: connector.otherPartyConnectionId) {
                let extensionValue: MeeExtenstionEntry = .init(domain: connector.otherPartyConnectionId, gpcEnabled: attributes.gpcEnabled, updated: Date().iso8601withFractionalSeconds)
                extensionSharedDefaults?.set(encodeJson(extensionValue), forKey: extensionValue.domain)
                print("cache: ", extensionValue)
            }
        }
    }
    
    private func getAllConnectors (callback: ([MeeConnectorWrapper]) -> Void) {
        guard let agent else {
            callback([])
            return
        }
        
        do {
            checkExtensionUpdates()
            let connectionsCore = try agent.otherPartyConnections();
            let allConnectorsCore = connectionsCore.reduce([]) { (acc: [MeeConnectorWrapper], connectionCore) in
                var copy = acc
                let connectorsCore = getAllConnectionConnectors(connectionId: connectionCore.id)
                
                copy.append(contentsOf: connectorsCore)
                return copy
            }
            
            updateExtensionCache(allConnectorsCore)
            callback(allConnectorsCore)
        } catch {
            print("error getting all contexts: \(error)")
            callback([])
        }
    }
    
    func getAllConnectors () async -> [MeeConnectorWrapper] {
        return await withCheckedContinuation { continuation in
            guard let agent else {
                continuation.resume(returning: [])
                return
            }
            
            do {
                checkExtensionUpdates()
                let connectionsCore = try agent.otherPartyConnections();
                let allConnectorsCore = connectionsCore.reduce([]) { (acc: [MeeConnectorWrapper], connectionCore) in
                    var copy = acc
                    let connectorsCore = getAllConnectionConnectors(connectionId: connectionCore.id)
                    
                    copy.append(contentsOf: connectorsCore)
                    return copy
                }
                
                updateExtensionCache(allConnectorsCore)
                continuation.resume(returning: allConnectorsCore)
            } catch {
                print("error getting all contexts: \(error)")
                continuation.resume(returning: [])
            }
        }
    }
    
    func removeConnector(connector: MeeConnectorWrapper) async -> String? {
        guard let agent else {
            return nil
        }
        let item = await self.getConnectionById(id: connector.otherPartyConnectionId)
            guard let id = item?.id else {
                return nil
            }
            return await withCheckedContinuation { continuation in
                do {
                    if connector.isGapi {
                        print("googleApiProviderDetachAccount")
                        try agent.googleApiProviderDetachAccount(connectorId: connector.id)
                    } else {
                        print("deleteOtherPartyConnection: ", id)
                        try agent.deleteOtherPartyConnection(connId: id)
                    }
                    continuation.resume(returning: id)
                } catch {
                    continuation.resume(returning: nil)
                }
                
            }

    }

    private func getConnectionById (id: String) async -> MeeConnectionWrapper? {
        let items = await self.getAllConnections()
        let item = items.first { $0.id == id }
        guard let item else {
            return nil
        }
        return item

    }
    
    func getConnectorById(id: String) async -> MeeConnectorWrapper? {
        let connectors = await getAllConnectors()
        let connector = connectors.first { $0.id == id }
        guard let connector else {
            return nil
        }
        return connector
    }
    
    func checkSiopConnectionExists (id: String) async -> Bool {
        return (try? agent?.siopLastConsentByConnectionId(connId: id)) != nil
    }
    
    func getLastSiopConsentByConnectionId (id: String) async -> MeeContextWrapper? {
        if let consent = try? agent?.siopLastConsentByConnectionId(connId: id) {
            return MeeContextWrapper(from: consent)
        }
        return nil
    }
    
    internal func getLastConsentByConnectorId(id: String) -> MeeContextWrapper? {
        guard let agent else {
            return nil
        }
        do {
            if let coreConsent = try agent.siopLastConsentByConnectorId(connId: id) {
                return MeeContextWrapper(from: coreConsent)
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func getLastConsentByConnectorId(id: String) async -> MeeContextWrapper? {
        return await withCheckedContinuation { continuation in
            let result = getLastConsentByConnectorId(id: id)
            continuation.resume(returning: result)
        }
    }
    
    func getLastExternalConsentById(connectorId: String) async -> MeeExternalContextWrapper? {
        guard let agent else {
            return nil
        }
        return await withCheckedContinuation {continuation in
            do {
                let coreConsent = try agent.otherPartyContextsByConnectorId(connectorId: connectorId)
                guard coreConsent.count > 0 else {
                    continuation.resume(returning: nil)
                    return
                }
                let result = MeeExternalContextWrapper(from: coreConsent[0])
                continuation.resume(returning: result)
            } catch {
                continuation.resume(returning: nil)
            }
        }
    }
    
    

    func authorize (id: String, item: MeeConsentRequest) async -> OidcAuthResponseWrapper? {
        guard let agent else {
            return nil
        }
        return await withCheckedContinuation { continuation in
            do {
                let response = try agent.siopAuthRelyingParty(authRequest: OidcAuthRequest(from: item))
                continuation.resume(returning: response)
            } catch {
                print(error)
                continuation.resume(returning: nil)
            }
        }
       
    }
    
    func getGoogleIntegrationUrl() async -> URL? {
        guard let agent else {
            return nil
        }
        return await withCheckedContinuation { continuation in
            do {
                let url = try agent.googleApiProviderCreateOauthBrowsableUrl()
                continuation.resume(returning: URL(string: url))
            } catch {
                continuation.resume(returning: nil)
            }
        }
        
    }
    
    @MainActor func createGoogleConnectionAsync (url: URL) async throws {
        try await self.createGoogleConnection(url: url)
    }
    
    private func createGoogleConnection (url: URL) async throws {
        guard let agent else {
            return
        }
        let _ = try agent.googleApiProviderCreateOauthConnection(oauthResponseUrl: url.absoluteString)

        onConnectionsListUpdated()
    }
    
    @MainActor func createExtensionConnectionAsync (url: String, gpcEnabled: Bool) async throws {
        try self.createExtensionConnection(url: url, gpcEnabled: gpcEnabled)
    }
    
    private func createExtensionConnection (url: String, gpcEnabled: Bool) throws {
        guard let agent else {
            return
        }
        let _ = try agent.meeBrextUpdateSiteAttributes(siteHostname: url, attributes: .init(gpcEnabled: gpcEnabled))
        onConnectionsListUpdated()
    }
    
    func authAuthRequestFromUrl (url: String, isCrossDevice: Bool, sdkVersion: SdkVersion) async -> MeeConsentRequest? {
        return await withCheckedContinuation { continuation in
            do {
                let partnerData = try siopRpAuthRequestFromUrl(siopUrl: url)
                
                let consent = MeeConsentRequest(from: partnerData, isCrossDevice: isCrossDevice, sdkVersion: sdkVersion)

                continuation.resume(returning: consent)
            } catch {
                print(error)
                continuation.resume(returning: nil)
            }
        }
    }
    
}

