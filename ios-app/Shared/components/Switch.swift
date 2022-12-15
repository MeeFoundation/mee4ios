//
//  Switch.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 23.03.2022.
//

import Foundation
import SwiftUI

struct Switch: View {
    @Binding var isOn: Bool
    var title: String? = nil
    
    var body: some View {
        Group {
            HStack {
                if title != nil {
                    BasicText(text: title, color: Colors.text, size: 16, align: VerticalAlign.left)
                    Spacer()
                }
                Toggle(isOn: $isOn) {}
                .frame(width: 60)
            }
            Divider()
        }
    }
}
