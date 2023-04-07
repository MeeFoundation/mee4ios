//
//  ConsentCardEntryInput.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 23.3.23..
//

import SwiftUI
import Combine

struct ConsentCardEntryInput: View {
    @Binding var value: CreditCardEntry
    var isIncorrect: Bool
    var name: String
    var isRequired: Bool
    var type: ConsentEntryType
    var isReadOnly: Bool
    
    init(value: Binding<CreditCardEntry>, name: String, isRequired: Bool, type: ConsentEntryType, isIncorrect: Bool, isReadOnly: Bool) {
        self._value = value
        self.name = name
        self.isRequired = isRequired
        self.type = type
        self.isIncorrect = isIncorrect
        self.isReadOnly = isReadOnly
    }
    @State private var calendarVisible = false
    @State private var date: Date = Date()
    
    var body: some View {
        Group {
            VStack {
                TextField("Card number", text:  optionalBinding(binding: $value.number))
                .autocorrectionDisabled(true)
                HStack(spacing: 20) {
                    TextField("MM/YY", text:  optionalBinding(binding: $value.expirationDate))
                    .autocorrectionDisabled(true)
                    .frame(width: 60)
                    TextField("CVC", text:  optionalBinding(binding: $value.cvc))
                    .autocorrectionDisabled(true)
                    .frame(width: 60)
                        
                    Spacer()
                }
                
            }
            .disabled(isReadOnly)
            .preferredColorScheme(.light)
            .foregroundColor(Colors.text)
            .multilineTextAlignment(.leading)
            .padding(EdgeInsets(top: 11, leading: 16, bottom: 11, trailing: 16))
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1.0)
                    .fill(isIncorrect ? Colors.error : Colors.gray)
            )
        }
        .padding(.horizontal, 1)
        .padding(.top, 4.0)
    }
}
