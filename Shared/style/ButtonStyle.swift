//
//  ButtonStyle.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 18.02.2022.
//

import SwiftUI

struct MainButtonStyle: ButtonStyle {
    var color: Color = Colors.mainButtonColor
    
    public func makeBody(configuration: MainButtonStyle.Configuration) -> some View {
        
        configuration.label
            .padding()
            .foregroundColor(color)
    }
}

struct DestructiveButtonStyle: ButtonStyle {
    var color: Color = Color.red
    
    public func makeBody(configuration: MainButtonStyle.Configuration) -> some View {
        
        configuration.label
            .padding()
            .foregroundColor(color)
    }
}

struct RoundedCorners: ButtonStyle {
 
    var color: Color
    var background: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(background)
            .padding(10)
            .overlay(
                   RoundedRectangle(cornerRadius: 10)
                       .stroke(color, lineWidth: 1)
               )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        }
}
