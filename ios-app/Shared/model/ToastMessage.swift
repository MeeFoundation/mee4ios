//
//  ToastMessage.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 17.4.23..
//

import Foundation

enum ToastStyle {
    case error
    case warning
    case success
    case info
}

struct ToastMessage: Equatable {
    var type: ToastStyle
    var title: String
    var message: String
    var duration: Double = 3
}
