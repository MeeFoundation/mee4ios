//
//  SecureInputField.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 21.02.2022.
//

import SwiftUI

struct SearchInput: View {
    @Binding private var text: String?
    private var title: String
    private var type: UITextContentType?
    @Binding var error: String?
    private var autocapitalization: Bool?
    @StateObject private var voiceRecognition = VoiceRecognition()
    
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
                HStack {
                    Image("inputFieldSearchIcon")
                        .foregroundColor(Colors.text)
                    TextField(title, text: optionalBinding(binding: $text), prompt: Text(title).foregroundColor(Colors.text))
                        .disableAutocorrection(true)
                        .font(.custom(FontNameManager.PublicSans.regular, size: 17))
                        .textContentType(type)
                        .autocapitalization(autocapitalization ?? false ? .sentences : .none)
                        .padding(0)
                        .onChange(of: text) { [] newValue in
                            error = nil
                        }
                    Spacer()
                    Button(action: {
                        
                        voiceRecognition.requestSpeech()
                    }) {
                        Image(voiceRecognition.isRecording ? "microphoneIconMeeColor" : "microphoneIcon")
                            .foregroundColor(Colors.text)
                    }
                }
                .frame(height: 36)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                .background(Colors.lightGray.opacity(0.18))
                .padding(0)
                .cornerRadius(10)
                BasicText(text: error, color: Colors.error, size: 14, align: VerticalAlign.left)
            }
        }
        .onChange(of: voiceRecognition.text, perform: { newText in
            text = newText
        })
    }
}
