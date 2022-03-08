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
    @Binding var error: String
    
    init(_ title: String, text: Binding<String>, error: Binding<String>? = nil) {
        self.title = title
        self._text = text
        self._error = error ?? Binding.constant("")
    }
    
    var body: some View {
        VStack {
            TextField(title, text: $text)
                .font(.custom(FontNameManager.PublicSans.regular, size: 16))
                .frame(height: 48)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .padding(0)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(error == "" ? Colors.text : Color.red, lineWidth: 1.0)
                )
                .onChange(of: text) { [] newValue in
                    error = ""
                }
            error != "" ?
                Text(error).foregroundColor(.red).padding(0)
                : nil
        }
    }
}
