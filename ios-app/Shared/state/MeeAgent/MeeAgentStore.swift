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


class MeeAgentStore {
    private let agent: MeeAgent
    static let shared = MeeAgentStore()
    var listeners: [MeeAgentStoreListener] = []
    
    private func onConnectionsListUpdated() {
        for listener in listeners {
            listener.onUpdate()
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
        let storage = KeyChainStorage()
        var passcode: String? = storage.getItem(name: MEE_KEYCHAIN_SECRET_NAME)
        if passcode == nil {
            passcode = generateSecret(length: 30)
            storage.editItem(name: MEE_KEYCHAIN_SECRET_NAME, value: passcode!)
        }
        guard let passcode else {
            fatalError("Unable to init Mee Smartwallet")
        }

        let fm = FileManager.default
        do {
            let folderURL = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dbURL = folderURL.appendingPathComponent("mee.sqlite")
            print(dbURL)
            if !fm.fileExists(atPath: dbURL.path) {
                fm.createFile(atPath: dbURL.path, contents: nil)
            }
            
            agent = try getAgent(config: MeeAgentConfig(dsUrl: dbURL.path, grandPassword: passcode, dsEncryptionPassword: nil, didRegistryConfig: MeeAgentDidRegistryConfig.didKey))
            
            try agent.initUserAccount()

        } catch {
            fatalError("Unable to init Mee Smartwallet: \(error)")
        }
  
    }
    
    private func getAllItems (callback: ([Connection]) -> Void) {
        do {
            let contextsCore = try agent.otherPartyConnections();
            print("contextsCore: ", contextsCore)
            let connections = contextsCore.reduce([]) { (acc: [Connection], connection) in
                var copy = acc
                
                if let connection = Connection(from: connection) {
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
    
    func getAllItems () async -> [Connection] {
        return await withCheckedContinuation { continuation in
            getAllItems { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    private func getAllContexts(callback: ([Context]?) -> Void) {
        do {
            let contextsCore = try agent.otherPartyConnections();
            let connections = contextsCore.reduce([]) { (acc: [Context], connection) in
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
    
    func getAllContexts() async -> [Context]? {
        return await withCheckedContinuation { continuation in
            getAllContexts { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    func removeItembyName (id: String) async -> String? {
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

    func getConnectionById (id: String) async -> Connection? {
        let items = await self.getAllItems()
        let item = items.first { $0.id == id }
        guard let item else {
            return nil
        }
        return item

    }
    
    private func getLastConnectionConsentById(id: String) -> Context? {
        do {
            if let coreConsent = try agent.siopLastConsentByConnectionId(connId: id) {
                return Context(from: coreConsent)
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func getLastConnectionConsentById(id: String) async -> Context? {
        return await withCheckedContinuation { continuation in
            let result = getLastConnectionConsentById(id: id)
            continuation.resume(returning: result)
        }
    }
    
    func getLastExternalConsentById(id: String) async -> ExternalContext? {
        return await withCheckedContinuation {continuation in
            do {
                let coreConsent = try agent.otherPartyContextsByConnectionId(connId: id)
                guard coreConsent.count > 0 else {
                    continuation.resume(returning: nil)
                    return
                }
                let result = ExternalContext(from: coreConsent[0])
                continuation.resume(returning: result)
            } catch {
                continuation.resume(returning: nil)
            }
        }
        
        
    }

    func authorize (id: String, item: ConsentRequest) async -> RpAuthResponseWrapper? {
        return await withCheckedContinuation { continuation in
            do {
                print("ar: ", RpAuthRequest(from: item))
                let response = try agent.siopAuthRelyingParty(authRequest: RpAuthRequest(from: item))
                onConnectionsListUpdated()
                continuation.resume(returning: response)
            } catch {
                print(error)
                continuation.resume(returning: nil)
            }
        }
       
    }
    
    func getGoogleIntegrationUrl() async -> URL? {
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
        try self.agent.googleApiProviderCreateOauthConnection(oauthResponseUrl: url.absoluteString)
        onConnectionsListUpdated()
    }
    
    func authAuthRequestFromUrl (url: String, isCrossDevice: Bool, sdkVersion: SdkVersion) async -> ConsentRequest? {
        return await withCheckedContinuation { continuation in
            do {
                let partnerData = try siopRpAuthRequestFromUrl(siopUrl: url)
                let consent = ConsentRequest(from: partnerData, isCrossDevice: isCrossDevice, sdkVersion: sdkVersion)

                continuation.resume(returning: consent)
            } catch {
                print(error)
                continuation.resume(returning: nil)
            }
        }
    }
    
}

