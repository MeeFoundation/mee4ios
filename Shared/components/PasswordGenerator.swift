//
//  PasswordGenerator.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 23.03.2022.
//

import Foundation
import SwiftUI

struct PasswordGenerator: View {
    @State private var length = 10.0
    @State private var isSpecialSymbolsOn = true
    @State private var isUppercaseOn = true
    @State private var isNumbersOn = true
    @State private var generatedPassword: String? = nil
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var onAccept: (_ result: String) -> Void
    
    var body: some View {
        ZStack {
            VStack {
                BasicText(text: "Password length: \(String(format: "%.0f", length))", size: 16, align: VerticalAlign.left)
                HStack {
                    BasicText(text: "4")
                    Slider(
                        value: $length,
                        in: 4...40,
                        step: 1,
                        onEditingChanged: { editing in
                            
                        }
                    )
                        .accentColor(Colors.mainButtonColor)
                    BasicText(text: "40")
                    //BasicText(text: String(format: "%.0f", length))
                }
                .padding(.bottom, 45)
                Switch(isOn: $isSpecialSymbolsOn, title: "Allow special symbols")
                Switch(isOn: $isUppercaseOn, title: "Allow uppercase letters")
                Switch(isOn: $isNumbersOn, title: "Allow numbers")
                MainButton("Generate", action: {
                    generatedPassword = generatePassword(isSpecialSymbolsOn, isUppercaseOn, isNumbersOn, Int(length))
                }, image: Image(systemName: "lock.rotation.open"), fullWidth: true)
                    .padding(.top, 35)
                if generatedPassword != nil {InputView("Generated password", text: $generatedPassword).padding(.top, 30)}
                Spacer()
                VStack {
                    MainButton("Use", action: {
                        onAccept(generatedPassword!)
                        self.presentationMode.wrappedValue.dismiss()
                    }, image: Image(systemName: "wand.and.rays"), fullWidth: true, isDisabled: generatedPassword == nil)
                    DestructiveButton("Cancel", action: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                }
            }
            .padding(.top, 40)
            .padding(.horizontal, 50)
            .background(Colors.background)
        }
    }
}
