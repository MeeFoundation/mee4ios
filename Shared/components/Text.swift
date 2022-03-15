//
//  SecureInputField.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 21.02.2022.
//

import SwiftUI

enum VerticalAlign {
    case left
    case right
    case center
}

struct BasicText: View {
    var text: String?
    var color = Colors.text
    var size: CGFloat = 18
    var align: VerticalAlign? = VerticalAlign.center
    
    var body: some View {
        if text != nil {
            HStack {
                if align == VerticalAlign.right { Spacer() }
                Text(text!)
                    .foregroundColor(color)
                    .font(.custom(FontNameManager.PublicSans.regular, size: size))
                if align == VerticalAlign.left { Spacer() }
            }
        }
    }
}
