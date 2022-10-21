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
    var textAlignment = TextAlignment.center
    var fontName: String = FontNameManager.PublicSans.regular
    var underline: Bool = false
    
    var body: some View {
        if text != nil {
            HStack {
                if align == VerticalAlign.right { Spacer() }
                Text(text ?? "")
                    .underline(color: underline ? color : Color.white.opacity(0))
                    .foregroundColor(color)
                    .font(.custom(fontName , size: size))
                    .multilineTextAlignment(textAlignment)
                if align == VerticalAlign.left { Spacer() }
            }
        }
    }
}
