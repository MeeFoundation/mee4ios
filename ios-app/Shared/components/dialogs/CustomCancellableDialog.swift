//
//  AllSetDialog.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 3.10.23..
//

import SwiftUI

struct CustomCancellableDialog<Content: View>: View {
    let text: String
    var onCancel: () -> Void
    @State private var contentHeight: CGFloat = 0
    @ViewBuilder let content: Content
    var body: some View {
        ZStack {
            VStack {
                Image("homeIndicatorImage")
                    .padding(.top, 8)
                HStack {
                    Button(action: onCancel) {
                        BasicText(text: "Cancel", color: Colors.mainButtonTextColor, size: 17)
                    }
                    .padding(.trailing, 20)
                    BasicText(text: text, size: 17, weight: .semibold)
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .frame(height: 1)
                    .foregroundColor(Colors.separatorLight.opacity(0.36))
                    .padding(.top, 16)
                
                ScrollView {
                    
                        content
                        .overlay {
                            GeometryReader {gr in
                                Color.clear
                                    .onChange(of: gr.size.height) { newHeight in
                                        contentHeight = newHeight
                                    }
                            }
                    }
                    
                }
                .frame(maxHeight: contentHeight)
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 45)
            .padding(.top, 4)
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
