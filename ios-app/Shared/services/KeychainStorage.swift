import Foundation
import KeychainAccess


class KeyChainStorage {
    private let keychain = Keychain(service: "59TG46326T.foundation.mee.ios-client").accessibility(.whenUnlocked)
    
    func removeItem(name: String) {
        keychain[name] = nil
    }
    
    func getItem(name: String) -> String? {
        do {
            return try keychain.get(name)
        } catch {
            return nil
        }
        
    }
    
    func editItem(name: String, value: String) {
        keychain[name] = value
        
    }
}
