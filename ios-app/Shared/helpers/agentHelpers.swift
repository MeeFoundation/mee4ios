//
//  agentHelpers.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 16.11.23..
//

import Foundation

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
