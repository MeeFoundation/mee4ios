//
//  SecureInputField.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 21.02.2022.
//

import SwiftUI

struct InputView: View {
    @Binding private var text: String?
    private var title: String
    @Binding var error: String?
    
    init(_ title: String, text: Binding<String?>, error: Binding<String?>? = nil) {
        self.title = title
        self._text = text
        self._error = error ?? Binding.constant(nil)
    }
    
    var body: some View {
        VStack {
            TextField(title, text: optionalBinding(binding: $text))
                .font(.custom(FontNameManager.PublicSans.regular, size: 16))
                .frame(height: 48)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .padding(0)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(error == nil ? Colors.text : Colors.error, lineWidth: 1.0)
                )
                .onChange(of: text) { [] newValue in
                    error = nil
                }
            BasicText(text: error, color: Colors.error, size: 14, align: VerticalAlign.left)
        }
    }
}
