//
//  Badge.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 7.5.24..
//

import SwiftUI

struct Badge: View {
    var text: String
    var body: some View {
        BasicText(text: text, color: Colors.meeBrand, size: 12)
            .padding(.vertical, 2)
            .padding(.horizontal, 4)
            .cornerRadius(3)
            .background(Colors.gray100)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Colors.meeBrand.opacity(0.5), lineWidth: 1)
            )
    }
}
