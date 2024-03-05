//
//  MeeAgentStoreListener.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 16.11.23..
//

import Foundation

protocol MeeAgentStoreListener {
    nonisolated var id: UUID {get}
    nonisolated func onUpdate()
}
