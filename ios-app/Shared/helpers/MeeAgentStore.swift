//
//  keyChain.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.03.2022.


import Foundation
import KeychainAccess
import AuthenticationServices

//class MeeAgentStore {
//    private let store = ASCredentialIdentityStore.shared
//    init() {
//        keychain = Keychain(service: "org.getmee.ios-client", accessGroup: "59TG46326T.org.getmee.ios-client.connections").synchronizable(true)
//    }
//    private var keychain: Keychain
//
//    func removeItembyName (name: String) -> Void {
//        do {
//            try keychain.remove(name)
//            return
//        } catch {
//            return
//        }
//    }
//
//    func getItemByName (name: String) -> String? {
//        do {
//            guard let oneItem = try keychain.get(name) else {
//                return nil
//            }
//            return oneItem
//        } catch {
//            return nil
//        }
//
//    }
//
//    func editItem (name: String, item: String) {
//        do {
//            try keychain.set(item, key: name)
//        } catch {
//
//        }
//
//    }
//}



class MeeAgentStore {
    private let agent: MeeAgent
    init() {
        let fm = FileManager.default
        do {
            let folderURL = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dbURL = folderURL.appendingPathComponent("mee.sqlite")
            agent = getAgent(databaseUrl: dbURL.path)

        } catch {
            fatalError("Unable to init Mee Agent")
        }
        
    }
    
    func removeItembyName (name: String) -> String? {
        do {
            try agent.deleteCtx(ctxId: name)
            return name
        } catch {
            return nil
        }
    }

    func getItemByName (name: String) -> String? {
        do {
            guard let oneItem = try agent.getCtx(ctxId: name)?.data else {
                return nil
            }
            return oneItem
        } catch {
            return nil
        }
    }

    func editItem (name: String, item: String) -> DsContainer? {
        do {
            if (getItemByName(name: name)) != nil {
                self.removeItembyName(name: name)
            }
            return try agent.createCtx(ctxId: name, ctxName: name, ctxData: item)
        } catch let e {
            print("error: ", e)
            return nil
        }
    }
}
