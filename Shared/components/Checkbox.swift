//
//  Checkbox.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 16.8.22..
//

import SwiftUI

struct Checkbox: View {
    @Binding var isToggled: Bool
    var body: some View {
        HStack {
            Rectangle()
                .foregroundColor(isToggled ? .green : .gray)
                .cornerRadius(10)
                .frame(width: 36, height: 16, alignment: .center)
        }
        .overlay(
            Rectangle()
                .frame(width: 20, height: 20, alignment: .center)
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Colors.grey, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.06), radius: 2.0, x: 0, y: 1.0)
                .shadow(color: Color.black.opacity(0.1), radius: 3.0, x: 0, y: 1.0)
                .cornerRadius(10)
                .offset(x: isToggled ? 11 : -11, y: 0)
            
        )
        .frame(width: 44, height: 44, alignment: .center)
        .onTapGesture { withAnimation {
            isToggled.toggle()
        }
        }
    }
}
