//
//  AllSetDialog.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 3.10.23..
//

import SwiftUI

struct DestructionConfirmationDialog: View {
    let text: String
    let description: String
    let buttonText: String
    var onNext: () -> Void
    var onCancel: () -> Void
    var body: some View {
        ZStack {
            VStack {
                Image("homeIndicatorImage")
                    .padding(.top, 8)
                HStack {
                    BasicText(text: text, size: 17, weight: .semibold)
                    Spacer()
                    Button(action: onCancel) {
                        BasicText(text: "Cancel", color: Colors.mainButtonTextColor, size: 17)
                    }
                }
                .padding(.top, 16)
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .frame(height: 1)
                    .foregroundColor(Colors.separatorLight.opacity(0.36))
                    .padding(.top, 16)
                BasicText(text: description, size: 16)
                    .padding(.top, 16)
                MainButton(buttonText, action: onNext, fullWidth: true, textColor: Colors.destructiveAction, textFontWeight: .semibold)
                    .padding(.bottom, 64)
                    .padding(.top, 16)
                
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
        }
        .background(Colors.popupBackground)
        .cornerRadius(10)
        .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.height > 20 {
                    onCancel()
                    
                }
            }))
    }
}
