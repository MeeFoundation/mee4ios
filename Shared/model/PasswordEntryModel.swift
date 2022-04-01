//
//  PasswordEntryModel.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 16.03.2022.
//
import Foundation

struct PasswordEntryModel: Identifiable & Codable {
    var id = UUID()
    var name: String?
    var username: String?
    var password: String?
    var url: String?
    var folder: String?
    var notes: String?
}
