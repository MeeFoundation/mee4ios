//
//  ToastStyleExtension.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 17.4.23..
//

import SwiftUI

extension ToastStyle {
    var themeColor: Color {
        switch self {
        case .error: return Colors.error
        case .warning: return Color.orange
        case .info: return Color.blue
        case .success: return Colors.meeBrand
        }
    }
    
    var iconFileName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
}
