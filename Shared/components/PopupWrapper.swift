//
//  Popup.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 3.11.22..
//

import SwiftUI

struct PopupButton: View {
    var text: String
    var onClick: () -> Void
    var body: some View {
        Button(action: onClick) {
            Text(text)
        }
    }
}

struct PopupWrapper<Content: View>: View {
    var isVisible: Bool
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            BackgroundFaded()
            VStack {
                Spacer()
                ZStack {
                    VStack {
                        content
                    }
                    .frame(maxWidth: .infinity)
                }
                .background(Colors.popupBackground)
                .cornerRadius(10)
                .ignoresSafeArea(.all)
            }
            
        }
        .ignoresSafeArea(.all)
        .opacity(isVisible ? 1 : 0)
        
    }
    
    
}
