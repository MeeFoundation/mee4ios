//
//  SecureInputField.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 21.02.2022.
//

import SwiftUI

struct SecureInputView: View {
    
    @Binding private var text: String
    @State private var isSecured: Bool = true
    private var title: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if isSecured {
                SecureField(title, text: $text)
                    .frame(height: 48)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 6))
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Colors.text, lineWidth: 1.0)
                    )
            } else {
                TextField(title, text: $text)
                    .frame(height: 48)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 6))
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Colors.text, lineWidth: 1.0)
                    )
            }
            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
                    .padding(.trailing, 4.0)
            }
        }
    }
}
