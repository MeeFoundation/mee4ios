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
    private var type: UITextContentType?
    @Binding var error: String?
    private var autocapitalization: Bool?
    
    init(_ title: String, text: Binding<String?>, error: Binding<String?>? = nil, type: UITextContentType? = .username, autocapitalization: Bool? = false) {
        self.title = title
        self._text = text
        self._error = error ?? Binding.constant(nil)
        self.type = type
        self.autocapitalization = autocapitalization
    }
    
    var body: some View {
        ZStack {
            VStack{
                VStack {
                    if text != nil { BasicText(text: title, color: Colors.text, size: 12, align: VerticalAlign.left) }
                    TextField(title, text: optionalBinding(binding: $text))
                        .disableAutocorrection(true)
                        .font(.custom(FontNameManager.PublicSans.regular, size: 16))
                        .textContentType(type)
                        .autocapitalization(autocapitalization ?? false ? .sentences : .none)
                        .padding(0)
                        .onChange(of: text) { [] newValue in
                            error = nil
                        }
                }
                .frame(height: 58)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .padding(0)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(error == nil ? Colors.text : Colors.error, lineWidth: 1.0)
                )
                BasicText(text: error, color: Colors.error, size: 14, align: VerticalAlign.left)
            }
        }
        .padding(.bottom, 10)
    }
}
