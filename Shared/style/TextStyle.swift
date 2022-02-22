//
//  TextStyle.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 21.02.2022.
//

import SwiftUI


struct H1TextStyle: TextFieldStyle {
    var color: Color = Colors.text
    
    func _body(configuration: TextField<Self._Label>) -> some View {
           configuration
            .foregroundColor(Colors.text)
            .font(.custom(FontNameManager.PublicSans.light, size: 40))
    }
}

struct H2TextStyle: TextFieldStyle {
    var color: Color = Colors.text
    
    func _body(configuration: TextField<Self._Label>) -> some View {
           configuration
            .foregroundColor(Colors.text)
            .font(.custom(FontNameManager.PublicSans.light, size: 52/2))
    }
}

struct H3TextStyle: TextFieldStyle {
    var color: Color = Colors.text
    
    func _body(configuration: TextField<Self._Label>) -> some View {
           configuration
            .foregroundColor(Colors.text)
            .font(.custom(FontNameManager.PublicSans.regular, size: 34/2))
    }
}

struct H4TextStyle: TextFieldStyle {
    var color: Color = Colors.text
    
    func _body(configuration: TextField<Self._Label>) -> some View {
           configuration
            .foregroundColor(Colors.text)
            .font(.custom(FontNameManager.PublicSans.bold, size: 18/2))
            .textCase(.uppercase)
    }
}

struct BodyTextStyle: TextFieldStyle {
    var color: Color = Colors.text
    
    func _body(configuration: TextField<Self._Label>) -> some View {
           configuration
            .foregroundColor(Colors.text)
            .font(.custom(FontNameManager.PublicSans.light, size: 18/2))
            .lineSpacing(27/2)
            .padding(.bottom, 16/2)
    }
}

struct StrongBodyTextStyle: TextFieldStyle {
    var color: Color = Colors.text
    
    func _body(configuration: TextField<Self._Label>) -> some View {
           configuration
            .foregroundColor(Colors.text)
            .font(.custom(FontNameManager.PublicSans.bold, size: 18/2))
            
    }
}
