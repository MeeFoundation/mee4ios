//
//  SecureInputField.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 21.02.2022.
//

import SwiftUI

struct SecureInputView: View {
    
    @Binding private var text: String?
    @State private var isSecured: Bool = true
    private var title: String
    @Binding var error: String?
    private var showAdditionalIcons: Bool?
    private var lockWithLocalAuth: Bool?
    @State private var copySuccessfullMessage = false
    @State private var showPasswordGenerator = false
    
    init(_ title: String, text: Binding<String?>, error: Binding<String?>? = nil, showAdditionalIcons: Bool? = false, lockWithLocalAuth: Bool? = false) {
        self.title = title
        self._text = text
        self._error = error ?? Binding.constant(nil)
        self.showAdditionalIcons = showAdditionalIcons
        self.lockWithLocalAuth = lockWithLocalAuth
    }
    
    func unlockPassword(success: Bool) {
        isSecured = !success
    }
    
    func copyToClipboard(success: Bool) {
        if success {
            UIPasteboard.general.string = text
            copySuccessfull()
        }
    }
    
    func copySuccessfull() {
        copySuccessfullMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            copySuccessfullMessage = false
        }
        
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack {
                        if text != nil { BasicText(text: title, color: Colors.text, size: 12, align: VerticalAlign.left) }
                        ZStack(alignment: .trailing) {
                            if isSecured {
                                SecureField(title, text: optionalBinding(binding: $text))
                                    .disableAutocorrection(true)
                                    .textContentType(.password)
                                    .font(.custom(FontNameManager.PublicSans.regular, size: 16))
                                    .onChange(of: text) { [] newValue in
                                        error = nil
                                    }
                            } else {
                                TextField(title, text: optionalBinding(binding: $text, fallback: ""))
                                    .disableAutocorrection(true)
                                    .textContentType(.password)
                                    .font(.custom(FontNameManager.PublicSans.regular, size: 16))
                                    .onChange(of: text) { [] newValue in
                                        error = ""
                                    }
                            }
                        }
                    }
                    HStack {
                        Button(action: {
                            if lockWithLocalAuth! && isSecured {
                                requestLocalAuthentication(unlockPassword)
                            } else {
                                isSecured.toggle()
                            }
                        }) {
                            Image(systemName: self.isSecured ? "eye.slash" : "eye")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 15.0, height: 15.0)
                                .accentColor(self.isSecured ? .gray : Colors.mainButtonTextColor)
                        }
                    }
                    
            }
                .frame(height: 58)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(error == nil ? Colors.text : Colors.error, lineWidth: 1.0)
                )
                if showAdditionalIcons! {
                    HStack {
                        MainButton("Generate", action: {
                            showPasswordGenerator = true
                        }, image: Image(systemName: "lock.rotation.open"), fullWidth: true, width: 160)
                            .sheet(isPresented: $showPasswordGenerator, content: {
                                PasswordGenerator(){result in
                                    text = result
                                }
                            })
                        Spacer()
                        MainButton("Copy", action: {
                            if lockWithLocalAuth! && isSecured {
                                requestLocalAuthentication(copyToClipboard)
                            } else {
                                copyToClipboard(success: true)
                            }
                        }, image: Image(systemName: "doc.on.doc"), fullWidth: true, width: 160)
                    }
                    .popup(isShowing: $copySuccessfullMessage, text: Text("Copied!"))
                    .padding(.top, 10)
                }
                BasicText(text: error, color: Colors.error, size: 14, align: VerticalAlign.left)
            }
        }
        .padding(.bottom, 10)
    }
}
