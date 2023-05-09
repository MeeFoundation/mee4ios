//
//  InformationPopup.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 13.10.22..
//

import SwiftUI

struct WarningPopup: View {
    var text: String
    let iconName: String?
    var onNext: () -> Void
    
    var body: some View {
        ZStack {
            BackgroundFaded()
            VStack {
                Spacer()
                ZStack {
                    VStack {
                        Image(iconName ?? "warningSign").resizable()
                            .frame(width: 60, height: 60, alignment: .center)
                            .padding(.top, 24)
                            .zIndex(10)
                        Text(text)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(Colors.text)
                            .font(.custom(FontNameManager.PublicSans.regular , size: 16))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                        MainButton("Continue", action: onNext, fullWidth: true)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 64)
                        
                    }
                    .frame(maxWidth: .infinity)
                }
                .background(Colors.popupBackground)
                .cornerRadius(10)
                .ignoresSafeArea(.all)
            }
        }
        
    }
    
}
