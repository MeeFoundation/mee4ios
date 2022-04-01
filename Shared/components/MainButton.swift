//
//  SecureInputField.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 21.02.2022.
//

import SwiftUI

struct MainButton: View {
    private var action: () -> Void
    private var title: String
    private var image: Image?
    private var fullWidth: Bool?
    private var width: CGFloat?
    private var isDisabled: Bool?
    
    private var color: Color
    
    init(_ title: String, action: @escaping () -> Void, image: Image? = nil, fullWidth: Bool? = false, width: CGFloat? = nil, isDisabled: Bool? = false) {
        self.title = title
        self.action = action
        self.image = image
        self.fullWidth = fullWidth
        self.width = width
        self.isDisabled = isDisabled
        self.color = isDisabled! ? Color.gray : Colors.mainButtonColor
    }
    
    var body: some View {
        Button(action: action)
            {
                HStack {
                    if fullWidth! {Spacer()}
                    image?.resizable().scaledToFit()
                    BasicText(text: title, color: color)
                    if fullWidth! {Spacer()}
                }
            }
            .foregroundColor(color)
            .frame(height: 48)
            .frame(width: width)
            .buttonStyle(RoundedCorners(color: color, background: Colors.background.opacity(0)))
            .disabled(isDisabled!)
    }
}

struct DestructiveButton: View {
    private var action: () -> Void
    private var title: String
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action)
            {
                Text(title)
                    .foregroundColor(.red)
                    .font(.custom(FontNameManager.PublicSans.medium, size: 18))
            }
            .padding()
            .foregroundColor(.red)
            
    }
}

struct SecondaryButton: View {
    private var action: () -> Void
    private var title: String
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action)
            {
                BasicText(text: title)
            }
            .padding()
            .foregroundColor(Colors.mainButtonColor)
    }
}

struct AddButton: View {
    private var action: () -> Void
    
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: action)
            {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Colors.mainButtonColor)
                    .background(Colors.mainButtonSecondaryColor)
                    .clipShape(Circle())
            }
            .padding()
            .foregroundColor(Colors.mainButtonColor)
    }
}
