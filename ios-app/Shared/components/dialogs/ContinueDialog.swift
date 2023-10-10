//
//  AllSetDialog.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 3.10.23..
//

import SwiftUI

struct ContinueDialog: View {
    let imageName: String
    let text: String
    let description: String
    let buttonText: String
    var onNext: () -> Void
    var body: some View {
        ZStack {
            VStack {
                Image(imageName).resizable()
                    .frame(width: 60.5, height: 60.5, alignment: .center)
                    .padding(.top, 14)
                    .zIndex(10)
                Text(text).font(Font.custom(FontNameManager.PublicSans.bold, size: 34))
                    .foregroundColor(Colors.text)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 16)
                    .multilineTextAlignment(.center)
                Text(description)
                    .foregroundColor(Colors.text)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                MainButton(buttonText, action: onNext, fullWidth: true, textFontWeight: .semibold)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 65)
                
            }
            .frame(maxWidth: .infinity)
        }
        .background(Colors.popupBackground)
        .cornerRadius(10)
    }
}
