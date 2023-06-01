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
    var value: String

    init(entry: (String, String)) {
        self.name = entry.0
        self.value = entry.1
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
                Text(value)
                    .foregroundColor(Colors.meeBrand)
                    .font(.custom(FontNameManager.PublicSans.regular, size: 18))
                Spacer()
            }
            
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 28)
    }
}


