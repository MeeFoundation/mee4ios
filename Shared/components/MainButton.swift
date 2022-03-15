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
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action)
            {
                Text(title)
                    .foregroundColor(Colors.text)
                    .font(.custom(FontNameManager.PublicSans.medium, size: 18))
            }
            .padding()
            .foregroundColor(Colors.mainButtonColor)
            .buttonStyle(RoundedCorners(color: Colors.mainButtonColor, background: Colors.background))
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
