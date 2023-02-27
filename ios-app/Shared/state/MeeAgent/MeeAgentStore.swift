//
//  keyChain.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.03.2022.


import Foundation

class MeeAgentStore {
    private let agent: MeeAgent
    init() {
        let fm = FileManager.default
        do {
            let folderURL = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dbURL = folderURL.appendingPathComponent("mee.sqlite")
            print(dbURL)
            agent = try getAgent(config: MeeAgentConfig(dsUrl: dbURL.path, dsEncryptionPassword: nil, didRegistryConfig: MeeAgentDidRegistryConfig.didKey))
            try agent.initSelfCtx()

        } catch {
            fatalError("Unable to init Mee Agent: \(error)")
        }
  
        
    }
    
    func getAllItems () -> [Context]? {
        do {
            let contextsCore = try agent.listMaterializedContexts();
            let contexts = contextsCore.reduce([]) { (acc: [Context], context) in
                var copy = acc
                if case let MaterializedContext.relyingParty(did, _, data) = context {
                    
                    if case let ContextProtocol.siop(siop) = data.protocol {
                        let claimsArrayLast = siop.claims.count - 1
                        let claims = siop.claims[claimsArrayLast]
                        if claimsArrayLast >= 0 {
                            let claimedDataConverted = claims.reduce([]) { (acc: [ConsentRequestClaim], rec) in
                                var copy = acc
                                if let value = rec.value,
                                   let request = ConsentRequestClaim(from: value, code: rec.key)
                                {
                                    copy.append(request)
                                }
                                return copy
                            }
                       
                            
                            copy.append(Context(id: siop.redirectUri, did: did, claims: claimedDataConverted, clientMetadata: PartnerMetadata(from: siop.clientMetadata)!))
                        }
                    }
                    
                    
                }
                return copy
            }
            return contexts
        } catch {
            print("error getting all contexts: \(error)")
            return nil
        }
       
    }
    
    func removeItembyName (id: String) -> String? {
        do {
            let item = self.getItemById(id: id)
            guard let did = item?.did else {
                return nil
            }
            try agent.deleteCtx(ctxId: did)
            return did
        } catch {
            return nil
        }
    }

    func getItemById (id: String) -> Context? {
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

    func authorize (id: String, item: ConsentRequest) -> RpAuthResponseWrapper? {
        
        do {
            print("ar: ", RpAuthRequest(from: item))
            let response = try agent.authRelyingParty(authRequest: RpAuthRequest(from: item))
            return response
        } catch {
            return nil
        }
    }
}
