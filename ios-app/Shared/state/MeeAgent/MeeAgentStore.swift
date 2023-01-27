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
            agent = try getAgent(databaseUrl: dbURL.path, dbEncryptionPassword: nil)
            try! agent.initSelfCtx()

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
                    let claimedDataConverted = data.claimedData.reduce([]) { (acc: [ConsentRequestClaim], rec) in
                        var copy = acc
                        if let value = rec.value,
                           let request = ConsentRequestClaim(from: value, code: rec.key)
                        {
                            copy.append(request)
                        }
                        return copy
                    }
                    copy.append(Context(did: did, claims: claimedDataConverted, clientMetadata: PartnerMetadata(from: data.meta)!))
                }
                return copy
            }
            return contexts
        } catch {
            return nil
        }
       
    }
    
    func removeItembyName (id: String) -> String? {
        do {
            try agent.deleteCtx(ctxId: id)
            return id
        } catch {
            return nil
        }
    }

    func getItemById (id: String) -> Context? {
        let items = self.getAllItems()
        guard let items else {
            return nil
        }
        let item = items.first { $0.did == id }
        guard let item else {
            return nil
        }
        return item

    }

    func authorize (id: String, item: ConsentRequest) -> RpAuthResponseWrapper? {
        print("item: ", item, RpAuthRequest(from: item))
        do {
            let response = try agent.authRelyingParty(authRequest: RpAuthRequest(from: item))
            return response
        } catch {
            print("error: ", error)
            return nil
        }
    }
}
