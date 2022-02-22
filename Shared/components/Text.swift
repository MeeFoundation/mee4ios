//
//  SecureInputField.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 21.02.2022.
//

import SwiftUI

struct BasicText: View {
    var text: String
    var color = Colors.text
    

    
    var body: some View {
        Text(text)
            .foregroundColor(color)
            .font(.custom(FontNameManager.PublicSans.regular, size: 18))
    }
}
