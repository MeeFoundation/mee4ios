//
//  SecureInputField.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 21.02.2022.
//

import SwiftUI

struct InputView: View {
    @Binding private var text: String
    private var title: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        TextField(title, text: $text)
            .frame(height: 48)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 6))
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Colors.text, lineWidth: 1.0)
            )
    }
}
