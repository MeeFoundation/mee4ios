//
//  keyChain.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.03.2022.


import Foundation

let MEE_KEYCHAIN_SECRET_NAME = "MEE_KEYCHAIN_SECRET_NAME"

let extensionSharedDefaults = UserDefaults(suiteName: "group.extensionshare.foundation.mee.ios-client")

class BrowserRedirector: BrowserRedirectCapability {
    func openUrl(url: Url) throws {
        if let urlParsed = URL(string: url) {
            openURL(urlParsed)
        }
        
    }
    
    var openURL: (URL) -> Void

    public init(openURL: @escaping (URL) -> Void) {
        self.openURL = openURL
    }
}

class MeeAgentStore: NSObject, ObservableObject, CoreAgent {
    var agent: MeeAgent?
    var error: AppErrorRepresentation? = nil
    var listeners: [MeeAgentStoreListener] = []
    var errorListeners: [MeeAgentStoreErrorListener] = []
    var gapiPlugin: GapiPlugin?
    var siopPlugin: SiopPlugin?
    
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
    
    func setup(openUrl: @escaping (_ url: URL) -> Void) {
        do {
            self.gapiPlugin = try agent?.getGapiPlugin(browserRedirectCapability: BrowserRedirector(openURL: openUrl))
            self.siopPlugin = try agent?.getSiopPlugin(browserRedirectCapability: BrowserRedirector(openURL: openUrl))
        } catch (let e) {
            onError((AppErrorRepresentation(error: errorToAppError(e), action: .initialization)))
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
            Task {
                await getAllConnectors()
            }
        }
    }
    
    deinit {
        extensionSharedDefaults?.removeObserver(self, forKeyPath: "meeExtensionQueue")
    }
    
    func reinit() throws {
        if let agent = try getNewAgent() {
            self.agent = agent
            let _ = try agent.initUserAccount()
            //                throw AppError.CoreError(MeeError.MeeStorage(error: .Other(error: "some error")))
        } else {
            throw AppError.UnknownError
        }
    }
        
    func removeAllData() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                guard let agent else {
                    continuation.resume()
                    throw AppError.UnknownError
                }
                
                try agent.deleteAllData()
                try reinit()
                continuation.resume()
            } catch(let e) {
                print(e)
                onError(AppErrorRepresentation(error: errorToAppError(e), action: .userDataRemoving))
                continuation.resume(throwing: e)
            }
        }
    }

    func getAllConnections () async -> [MeeConnectionWrapper] {
        return await withCheckedContinuation { continuation in
            guard let agent else {
                continuation.resume(returning: [])
                return
            }
            do {
                let connectionsCore = try agent.otherPartyConnections();
                print("connectionsCore: ", connectionsCore)
                let connections = try connectionsCore.reduce([]) { (acc: [MeeConnectionWrapper], connection) in
                    var copy = acc
                    let connectionConnectors = try agent.getOtherPartyConnectionConnectors(connId: connection.id)
                    if let connection = MeeConnectionWrapper(from: connection) {
                        if (connectionConnectors.count > 0) {
                            copy.append(connection)
                        }
                       
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
        clearExtensionCache()
        connectors.forEach { connector in
            if let attributes = try? agent?.meeBrextGetSiteAttributes(siteHostname: connector.otherPartyConnectionId) {
                let extensionValue: MeeExtenstionEntry = .init(domain: connector.otherPartyConnectionId, gpcEnabled: attributes.gpcEnabled, updated: Date().iso8601withFractionalSeconds)
                extensionSharedDefaults?.set(encodeJson(extensionValue), forKey: extensionValue.domain)
                print("cache: ", extensionValue)
            }
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
    
    func getAllTags () async -> [OtherPartyTagUniffi] {
        return await withCheckedContinuation { continuation in
            guard let agent else {
                continuation.resume(returning: [])
                return
            }
            
            do {
                let tagsCore = try agent.searchTags(substring: "");
                print("tags: ", tagsCore)
                continuation.resume(returning: tagsCore)
            } catch {
                print("error getting all contexts: \(error)")
                continuation.resume(returning: [])
            }
        }
    }
    
    func assignTagsToConnection(connectionId: String, tags: [OtherPartyTagUniffi]) async -> Void {
        return await withCheckedContinuation { continuation in
            guard let agent else {
                continuation.resume()
                return
            }
            do {
                try agent.assignTagsToConnection(connId: connectionId, tagIds: tags.map{$0.id})
                continuation.resume()
            } catch {
                continuation.resume()
            }
        }
    }
    
    func createTag(tag: String) async -> Void {
        return await withCheckedContinuation { continuation in
            guard let agent else {
                continuation.resume()
                return
            }
            do {
                let _ = try agent.getOrCreateTag(name: tag)
                print("tag: ", tag)
                continuation.resume()
            } catch {
                continuation.resume()
            }
        }
    }
    
    
    func removeConnection(connection: MeeConnectionWrapper) async throws {
        guard let agent else {
            throw AppError.UnknownError
        }
        return try await withCheckedThrowingContinuation { continuation in
            do {
                try agent.deleteOtherPartyConnection(connectionId: connection.id)
                onConnectionsListUpdated()
                continuation.resume()
            } catch(let e) {
                continuation.resume(throwing: e)
            }
            
        }
    }
    
    func removeConnector(connector: MeeConnectorWrapper) async throws {
        guard let agent else {
            throw AppError.UnknownError
        }
        let item = await self.getConnectionById(id: connector.otherPartyConnectionId)
        guard let id = item?.id else {
            throw AppError.UnknownError
        }
        return try await withCheckedThrowingContinuation { continuation in
            do {
                if connector.isGapi {
                    print("googleApiProviderDetachAccount")
                    try gapiPlugin?.detachGoogleAccount(connectorId: connector.id)
                } else {
                    print("deleteOtherPartyConnection: ", id)
//                    try agent.deleteOtherPartyConnection(connectionId: id)
                    try agent.deleteOtherPartyConnector(connectorId: connector.id)
                }
                onConnectionsListUpdated()
                continuation.resume()
            } catch(let e) {
                continuation.resume(throwing: e)
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
        return await getLastSiopConsentByRedirectUri(id: id) != nil
    }
    
    func getLastSiopConsentByRedirectUri (id: String) async -> MeeContextWrapper? {
        let allConnectors = await getAllConnectors()
        let consent = allConnectors.first { connector in
            if case .Siop(value: let siopConnector) = connector.connectorProtocol {
                return siopConnector.redirectUri == id
            }
            return false
        }
        if let consent {
            let context = await self.getLastConsentByConnectorId(id: consent.id)
            return context
        }

        return nil
    }
    
    internal func getLastConsentByConnectorId(id: String) -> MeeContextWrapper? {
        guard let agent else {
            return nil
        }
        do {
            if let coreConsent = try siopPlugin?.lastConsentByConnectorId(connId: id) {
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
    
    func getLastExternalConsentByConnectorId(connectorId: String) async -> MeeExternalContextWrapper? {
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
        guard let siopPlugin else {
            return nil
        }
        return await withCheckedContinuation { continuation in
            do {
                let response = try agent?.siopAuthRelyingParty(authRequest: OidcAuthRequest(from: item))
                continuation.resume(returning: response)
            } catch {
                print(error)
                continuation.resume(returning: nil)
            }
        }
       
    }
    
    func googleAuthRequest() async {
        return await withCheckedContinuation { continuation in
            do {
                try gapiPlugin?.authRequestRedirect()
                continuation.resume()
            } catch {
                
            }
        }
                       
    }
    
    @MainActor func createGoogleConnectionAsync (url: URL) async throws {
        try await self.createGoogleConnection(url: url)
    }
    
    private func createGoogleConnection (url: URL) async throws {
        try gapiPlugin?.handleAuthResponse(oauthResponseUrl: url.absoluteString)

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

