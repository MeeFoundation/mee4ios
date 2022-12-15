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
    @State private var useKeywords = false
    @State private var generatedPassword: String? = nil
    @State private var isKeywordsListOpen = false
    @State private var keywords: [KeywordEntry] = [KeywordEntry(value: "Summer"), KeywordEntry(value: "Evening"), KeywordEntry(value: "Black"), KeywordEntry(value: "Horror"), KeywordEntry(value: "Reachable"), KeywordEntry(value: "Bread"), KeywordEntry(value: "Slight")]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var onAccept: (_ result: String) -> Void
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
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
                                .accentColor(Colors.mainButtonTextColor)
                            BasicText(text: "40")
                            //BasicText(text: String(format: "%.0f", length))
                        }
                        .padding(.bottom, 45)
                        Group {
                            Switch(isOn: $isSpecialSymbolsOn, title: "Allow special symbols")
                            Switch(isOn: $isUppercaseOn, title: "Allow uppercase letters")
                            Switch(isOn: $isNumbersOn, title: "Allow numbers")
                            Switch(isOn: $useKeywords, title: "Use keywords")
                        }
                        
                
                        if useKeywords {
                            MainButton("Edit List", action: {
                                isKeywordsListOpen = true
                            }, image: Image(systemName: "list.bullet.circle.fill"), fullWidth: true)
                        }
                        Group {
                            MainButton("Generate", action: {
                                generatedPassword = generatePassword(isSpecialSymbolsOn, isUppercaseOn, isNumbersOn, keywords: useKeywords ? keywords : nil, Int(length))
                            }, image: Image(systemName: "lock.rotation.open"), fullWidth: true)
                                .padding(.top, 35)
                            if generatedPassword != nil {InputView("Generated password", text: $generatedPassword).padding(.top, 30)}
                        }
                    }
                    .padding(.horizontal, 50)
                }.fullScreenCover(isPresented: $isKeywordsListOpen) {
                    PasswordGeneratorList(keywords: $keywords)
                }

                
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
                .padding(.horizontal, 50)
            }
            .padding(.top, 40)
            .background(Colors.background)
        }
    }
}
