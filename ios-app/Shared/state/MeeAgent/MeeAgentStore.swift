//
//  keyChain.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.03.2022.


import Foundation

class MeeAgentStore {
    static let shared = MeeAgentStore()
    private let agent: MeeAgent
    init() {
        let fm = FileManager.default
        do {
            let folderURL = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dbURL = folderURL.appendingPathComponent("mee.sqlite")
            print(dbURL)
            fm.createFile(atPath: dbURL.path, contents: nil)
            agent = try getAgent(config: MeeAgentConfig(dsUrl: dbURL.path, grandPassword: "ShouldBeReplacedWithGeneratedPassword", dsEncryptionPassword: nil, didRegistryConfig: MeeAgentDidRegistryConfig.didKey))
            
            try agent.initUserAccount()

        } catch {
            fatalError("Unable to init Mee Agent: \(error)")
        }
  
    }
    
    func getAllItems () -> [Connection]? {
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
            
            return connections
        } catch {
            print("error getting all contexts: \(error)")
            return nil
        }
       
    }
    
    func getAllContexts () -> [Context]? {
        do {
            let contextsCore = try agent.otherPartyConnections();
            let connections = contextsCore.reduce([]) { (acc: [Context], connection) in
                var copy = acc
                if let context = getLastConnectionConsentById(id: connection.id) {
                    copy.append(context)
                }
                return copy
            }
            return connections
        } catch {
            print("error getting all contexts: \(error)")
            return nil
        }
       
    }
    
    func removeItembyName (id: String) -> String? {
        do {
            let item = self.getConnectionById(id: id)
            guard let id = item?.id else {
                return nil
            }
            try agent.deleteOtherPartyConnection(connId: id)
            return id
        } catch {
            return nil
        }
    }

    func getConnectionById (id: String) -> Connection? {
        let items = self.getAllItems()
        guard let items else {
            return nil
        }
        let item = items.first { $0.id == id }
        guard let item else {
            return nil
        }
        return item

    }
    
    func getLastConnectionConsentById(id: String) -> Context? {
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

    func authorize (id: String, item: ConsentRequest) -> RpAuthResponseWrapper? {
        
        do {
            print("ar: ", RpAuthRequest(from: item))
            let response = try agent.siopAuthRelyingParty(authRequest: RpAuthRequest(from: item))
            return response
        } catch {
            print(error)
            return nil
        }
    }
    
    func getGoogleIntegrationUrl() -> URL? {
        do {
            let url = try agent.googleApiProviderCreateOauthBrowsableUrl()
            return URL(string: url)
        } catch {
            return nil
        }
    }
    
    func createGoogleConnection (url: URL) async throws {
        Task.detached {
            try self.agent.googleApiProviderCreateOauthConnection(oauthResponseUrl: url.absoluteString)
        }
    }
}
