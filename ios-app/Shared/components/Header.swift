//
//  Header.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 3.10.23..
//

import SwiftUI

struct Header: View {
    let text: String
    let onBack: () -> Void
    var body: some View {
        HStack {
            Button(action: {
                onBack()
            }) {
                HStack {
                    Image(systemName: "chevron.backward")
                    
                    BasicText(text: "Back", color: Colors.mainButtonTextColor, size: 17)
                }
                .padding(.leading, 9)
            }
            Spacer()
            BasicText(text: text, color: .black ,size: 17, fontName: FontNameManager.PublicSans.semibold)
                .padding(.trailing, 69)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 59)
        .padding(.bottom, 10)
        .background(Colors.backgroundAlt1)
        .shadow(color: Color.black.opacity(0.3), radius: 0, x: 0, y: 0.5)
    }
}
