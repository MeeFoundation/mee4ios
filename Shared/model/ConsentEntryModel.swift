//
//  ConsentItemModel.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.02.2022.
//

import Foundation

struct ConsentModel {
    var name: String
    var entries: [ConsentEntryModel]
    var scopes: [String]
}

struct ConsentEntryModel: Identifiable {
    let id = UUID()
    let name: String
    let value: String? = nil
    var isRequired: Bool = false
    var canRead: Bool = false
    var canWrite: Bool = false
    var hasValue: Bool = true
}
