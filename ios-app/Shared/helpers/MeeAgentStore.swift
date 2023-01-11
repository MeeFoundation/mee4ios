//
//  keyChain.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.03.2022.


import Foundation
import AuthenticationServices

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
            print("error: ", error)
            return nil
        }
    }

    func editItem (name: String, item: String) -> DsContainer? {
        do {
            if (getItemByName(name: name)) != nil {
                let _ = self.removeItembyName(name: name)
            }
            return try agent.createCtx(ctxId: name, ctxName: name, ctxData: item)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}
