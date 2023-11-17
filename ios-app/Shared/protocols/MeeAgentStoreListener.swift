//
//  MeeAgentStoreListener.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 16.11.23..
//

import Foundation

protocol MeeAgentStoreListener {
    var id: UUID {get}
    func onUpdate()
}
