//
//  InformationPopup.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 13.10.22..
//

import SwiftUI

struct WarningPopup: View {
    var text: String
    var onNext: () -> Void
    
    var body: some View {
        ZStack {
            BackgroundFaded()
            VStack {
                Spacer()
                ZStack {
                    VStack {
                        Image("warningSign").resizable()
                            .frame(width: 45.03, height: 44.33, alignment: .center)
                            .padding(.top, 20)
                            .zIndex(10)
                        Text(text)
                            .fixedSize(horizontal: false, vertical: true)
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
