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
    @Binding var error: String?
    
    init(_ title: String, text: Binding<String>, error: Binding<String?>? = nil) {
        self.title = title
        self._text = text
        self._error = error ?? Binding.constant(nil)
    }
    
    var body: some View {
        VStack {
        ZStack(alignment: .trailing) {
            if isSecured {
                SecureField(title, text: $text)
                    .frame(height: 48)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(error == nil ? Colors.text : Colors.error, lineWidth: 1.0)
                    )
                    .onChange(of: text) { [] newValue in
                        error = ""
                    }
            } else {
                TextField(title, text: $text)
                    .font(.custom(FontNameManager.PublicSans.regular, size: 16))
                    .frame(height: 48)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(error == nil ? Colors.text : Colors.error, lineWidth: 1.0)
                    )
                    .onChange(of: text) { [] newValue in
                        error = ""
                    }
            }
            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 10.0, height: 10.0)
                    .accentColor(.gray)
                    .padding(.trailing, 15.0)
                
            }
        }
            BasicText(text: error, color: Colors.error, size: 14, align: VerticalAlign.left)
        }
    }
}
