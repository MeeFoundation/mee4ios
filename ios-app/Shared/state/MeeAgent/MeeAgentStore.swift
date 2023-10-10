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

class MeeAgentStore: ObservableObject {
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
    
    init() {
        do {
            if let agent = try getNewAgent() {
                self.agent = agent
                try agent.initUserAccount()
//                throw AppError.CoreError(MeeError.MeeStorage(error: .AppLevelMigration(error: "some error")))
            }
            
        } catch(let e) {
            print(e)
            error = AppErrorRepresentation(error: errorToAppError(e), action: .initialization)
            
        }
        
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
    
    private func removeAllData(callback: (Bool) -> Void) {
        guard let agent else {
            return callback(false)
        }
        do {
            try agent.deleteAllData()
            let result = reinit()
            callback(result)
        } catch(let e) {
            print(e)
            callback(false)
        }
        
    }
    
    func removeAllData() async -> Bool {
        return await withCheckedContinuation { continuation in
            removeAllData() { result in
                continuation.resume(returning: result)
            }
        }
        
        
        
    }
    
    private func getAllConnections (callback: ([MeeConnectionWrapper]) -> Void) {
        guard let agent else {
            callback([])
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
            
            callback(connections)
        } catch {
            print("error getting all contexts: \(error)")
            callback([])
        }
    }
    
    func getAllConnections () async -> [MeeConnectionWrapper] {
        return await withCheckedContinuation { continuation in
            getAllConnections { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    private func getAllConnectionConnectors (connectionId: String) -> [MeeConnectorWrapper] {
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
    
    private func getAllConnectors (callback: ([MeeConnectorWrapper]) -> Void) {
        guard let agent else {
            callback([])
            return
        }
        do {
            let connectionsCore = try agent.otherPartyConnections();
            let allConnectorsCore = connectionsCore.reduce([]) { (acc: [MeeConnectorWrapper], connectionCore) in
                var copy = acc
                let connectorsCore = getAllConnectionConnectors(connectionId: connectionCore.id)
                copy.append(contentsOf: connectorsCore)
                return copy
            }
            
            callback(allConnectorsCore)
        } catch {
            print("error getting all contexts: \(error)")
            callback([])
        }
    }
    
    func getAllConnectors () async -> [MeeConnectorWrapper] {
        return await withCheckedContinuation { continuation in
            getAllConnectors() { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    private func getAllContexts(callback: ([MeeContextWrapper]?) -> Void) {
        guard let agent else {
            callback(nil)
            return
        }
        do {
            let contextsCore = try agent.otherPartyConnections();
            let connections = contextsCore.reduce([]) { (acc: [MeeContextWrapper], connection) in
                var copy = acc
                if let context = getLastConnectionConsentById(id: connection.id) {
                    copy.append(context)
                }
                return copy
            }
            callback(connections)
        } catch {
            print("error getting all contexts: \(error)")
            callback(nil)
        }
       
    }
    
    func getAllContexts() async -> [MeeContextWrapper]? {
        return await withCheckedContinuation { continuation in
            getAllContexts { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    func removeItembyName (id: String) async -> String? {
        guard let agent else {
            return nil
        }
            let item = await self.getConnectionById(id: id)
            guard let id = item?.id else {
                return nil
            }
            return await withCheckedContinuation { continuation in
                do {
                    try agent.deleteOtherPartyConnection(connId: id)
                    continuation.resume(returning: id)
                } catch {
                    continuation.resume(returning: nil)
                }
                
            }

    }

    func getConnectionById (id: String) async -> MeeConnectionWrapper? {
        let items = await self.getAllConnections()
        let item = items.first { $0.id == id }
        guard let item else {
            return nil
        }
        return item

    }
    
    private func getLastConnectionConsentById(id: String) -> MeeContextWrapper? {
        guard let agent else {
            return nil
        }
        do {
            if let coreConsent = try agent.siopLastConsentByConnectionId(connId: id) {
                return MeeContextWrapper(from: coreConsent)
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func getLastConnectionConsentById(id: String) async -> MeeContextWrapper? {
        return await withCheckedContinuation { continuation in
            let result = getLastConnectionConsentById(id: id)
            continuation.resume(returning: result)
        }
    }
    
    func getLastExternalConsentById(id: String) async -> MeeExternalContextWrapper? {
        guard let agent else {
            return nil
        }
        return await withCheckedContinuation {continuation in
            do {
                let coreConsent = try agent.otherPartyContextsByConnectionId(connId: id)
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

