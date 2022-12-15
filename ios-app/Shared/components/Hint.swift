//
//  Hint.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct Hint: View {
    @Binding var show: Bool
    var text: String
    var body: some View {
        return (
            VStack(spacing: 0) {
                Triangle()
                    .fill(Colors.meeBrand)
                    .frame(width: 12, height: 6)
                VStack(spacing: 0) {
                    
                    BasicText(
                        text: text,
                        color: .white,
                        size: 14, textAlignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    Button(action: {
                        show = !show
                    }) {
                        BasicText(text: "Got it", color: .white, size:14).frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.top, 16)
                }
                
                .frame(width: 249)
                .padding(.horizontal, 16)
                .padding(.top, 28)
                .padding(.bottom, 16)
                .background(Colors.meeBrand)
                .cornerRadius(10)
                
                
            })
    }
}
