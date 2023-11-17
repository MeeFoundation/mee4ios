//
//  MeeAgentStoreErrorListener.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 16.11.23..
//

import Foundation

protocol MeeAgentStoreErrorListener {
    var id: UUID {get}
    func onError(error: AppErrorRepresentation)
}
