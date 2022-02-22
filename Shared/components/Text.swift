//
//  SecureInputField.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 21.02.2022.
//

import SwiftUI

struct BasicText: View {
    private var text: String

    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .foregroundColor(Colors.text)
            .font(.custom(FontNameManager.PublicSans.regular, size: 18))
    }
}
