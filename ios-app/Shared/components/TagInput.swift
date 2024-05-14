//
//  TagInput.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 7.5.24..
//

import Combine
import SwiftUI

extension OtherPartyTagUniffi: Identifiable {}

struct TagInput: View {
    @Binding private var text: String?
    @Binding private var isActive: Bool
    @FocusState private var isFocused: Bool
    private var allowTagCreation: Bool
    
    init(isActive: Binding<Bool>, text: Binding<String?>, allowTagCreation: Bool = false) {
        self.allowTagCreation = allowTagCreation
        self._isActive = isActive
        self._text = text
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                
                HStack(spacing: 0) {
                    if (isActive) {
                        TextField("enter tag name", text: optionalBinding(binding: $text), prompt: Text("enter tag name")
                            .foregroundColor(Colors.textInactive))
                            .disableAutocorrection(true)
                            .font(.custom(FontNameManager.PublicSans.regular, size: 17))
                            .keyboardType(.URL)
                            .focused($isFocused)
                            .autocapitalization(.none)
                            .textInputAutocapitalization(.never)
                            .padding(0)
                            .textCase(.lowercase)
                            .onReceive(Just(text ?? "")) { (newValue: String) in
                                            self.text = newValue.lowercased()
                                        }
                    } else {
                        
                        BasicText(text: "Tags", color: Colors.textInactive, size: 18, weight: Font.Weight.medium)
                    }
                    
                    Spacer()
                    
                    Image("searchInactive")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Colors.textInactive)
                        .padding(.vertical, 13)
                }
                .padding(.horizontal, 16)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isFocused ? Colors.meeBrand : Colors.textInactive, lineWidth: 1)
                )
                
                
            }
            .onChange(of: isActive) { a in
                isFocused = a
                text = nil
            }
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                isActive = !isActive
            }
            
        }
    }
}
