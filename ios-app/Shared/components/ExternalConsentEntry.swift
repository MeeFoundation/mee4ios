//
//  ExternalConsentEntry.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 18.5.23..
//

import SwiftUI

func getExternalConsentImageByName(_ name: String) -> String {
    switch (name) {
    case "familyName", "givenName", "name":
        return "personIcon"
    case "email":
        return "letterIcon"
    default:
        return "keyIcon"
    }
}

struct ExternalConsentEntry: View {
    var name: String
    @Binding var value: Any
    
    init(name: String, value: Binding<Any>) {
        self.name = name
        self._value = value
    }
    
    var body: some View {
        VStack{
            HStack {
                Image(getExternalConsentImageByName(name))
                    .resizable()
                    .scaledToFit()
                    .blending(Colors.meeBrand)
                    .frame(width: 18, height: 18, alignment: .center)
                    .padding(.trailing, 13)
                if let stringValue = value as? String {
                    Text(stringValue)
                        .foregroundColor(Colors.meeBrand)
                        .font(.custom(FontNameManager.PublicSans.regular, size: 18))
                } else if let boolValue = value as? Bool {
                    HStack {
                        Text(name)
                            .foregroundColor(Colors.meeBrand)
                            .font(.custom(FontNameManager.PublicSans.regular, size: 18))
                        Spacer()
                        Checkbox(isToggled: Binding(get: {
                            return boolValue
                        }, set: {newValue in
                            value = Bool(newValue)
                        }))
                    }
                }
                
                Spacer()
            }
            
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 28)
    }
}


