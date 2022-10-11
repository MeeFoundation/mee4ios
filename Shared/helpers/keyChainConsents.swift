//
//  keyChain.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.03.2022.


import Foundation
import KeychainAccess
import AuthenticationServices


class KeyChainConsents {
    private let store = ASCredentialIdentityStore.shared
    init() {
        keychain = Keychain(service: "mee-ios-client", accessGroup: "59TG46326T.org.getmee.ios-client.consent").synchronizable(true)
    }
    private var keychain: Keychain

    func removeItembyName (name: String) -> Void {
        do {
            try keychain.remove(name)
            return
        } catch {
            return
        }
    }
    
    func getItemByName (name: String) -> String? {
        do {
            guard let oneItem = try keychain.get(name) else {
                return nil
            }
            return oneItem
        } catch {
            return nil
        }
        
    }
    
    func editItem (name: String, item: String) {
        do {
            try keychain.set(item, key: name)
        } catch {
            
        }
        
    }
}
