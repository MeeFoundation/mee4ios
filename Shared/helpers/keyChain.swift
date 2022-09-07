//
//  keyChain.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.03.2022.


import Foundation
import KeychainAccess
import AuthenticationServices


class KeyChain {
    let store = ASCredentialIdentityStore.shared
    init() {
        keychain = Keychain(service: "mee-ios-client", accessGroup: "59TG46326T.org.getmee.ios-client.share").synchronizable(true)
    }
    private var keychain: Keychain
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    private func encodeItem (_ item: PasswordEntryModel) -> String? {
        do {
            let jsonItem = try encoder.encode(item)
            let stringItem = String(data: jsonItem, encoding: .utf8)!
            return stringItem
        } catch {
            return nil
        }
    }
    private func decodeItem (_ item: String) -> PasswordEntryModel? {
        do {
            let jsonItem = item.data(using: .utf8)!
            let data = try decoder.decode(PasswordEntryModel.self, from: jsonItem)
            return data
        } catch {
            return nil
        }
        
    }
    
    private func getStoreItemByKeychainItem(_ item: PasswordEntryModel) -> ASPasswordCredentialIdentity {
        return ASPasswordCredentialIdentity(
            serviceIdentifier: ASCredentialServiceIdentifier(identifier: item.url ?? "", type: .URL),
            user: item.username ?? "",
            recordIdentifier: item.id.uuidString)
    }
    
    func updateCredentialStore() {
        print("updating store")
        self.store.getState { state in
            if state.isEnabled {
                var creds: [ASPasswordCredentialIdentity] = []
                let keychainItems = self.getAllItems()
                for (_, keychainItem) in keychainItems {
                    creds.append(ASPasswordCredentialIdentity(
                        serviceIdentifier: ASCredentialServiceIdentifier(identifier: keychainItem.url ?? "", type: .URL),
                        user: keychainItem.username ?? "",
                        recordIdentifier: keychainItem.id.uuidString))
                }
        
                self.store.removeAllCredentialIdentities()
        
                self.store.replaceCredentialIdentities(with: creds)
            }
        }
    }
    
    func getAllItems () -> [String: PasswordEntryModel] {
        let items = keychain.allItems()
        var resultArray = [String: PasswordEntryModel]()
        for item in items {
            let key = item["key"]
            let data = self.decodeItem(item["value"] as! String)
            resultArray[key as! String] = data
        }
        return resultArray
    }
    
    func getAllKeys () -> [String] {
        return keychain.allKeys()
    }
    
    func removeItembyName (name: String) -> Bool {
        do {
            let oldItem = self.getItemByName(name: name)
            if oldItem != nil {
                let oldStoreItem = getStoreItemByKeychainItem(oldItem!)
                self.store.removeCredentialIdentities([oldStoreItem])
            }
            try keychain.remove(name)
            
            return true
        } catch {
            return false
        }
    }
    
    func getItemByName (name: String) -> PasswordEntryModel? {
        do {
            let oneItem = try keychain.authenticationPrompt("Authenticate to use Quick Type Bar").get(name)
            if oneItem == nil {return nil}
            return self.decodeItem(oneItem!)
        } catch {
            return nil
        }
        
    }
    
    func removeAllItems () -> Bool {
        do {
            try keychain.removeAll()
            self.store.removeAllCredentialIdentities()
            return true
        } catch {
            return false
        }
    }
    
    func editItem (item: PasswordEntryModel) {
        do {
            try keychain.set(self.encodeItem(item)!, key: item.id.uuidString)
            self.updateCredentialStore()
        } catch {
            
        }
        
    }
}
