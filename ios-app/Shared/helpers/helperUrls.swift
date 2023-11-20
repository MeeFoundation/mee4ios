//
//  helperUrls.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 17.11.23..
//

import SwiftUI

let FEEDBACK_URL = "mailto:contact@mee.foundation"

func openFeedbackUrl() {
    if let url = URL(string: FEEDBACK_URL) {
        UIApplication.shared.open(url)
    }
}

func openSettingsUrl() {
    if let url = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(url)
    }
}
