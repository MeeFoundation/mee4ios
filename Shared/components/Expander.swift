//
//  Expander.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 10.8.22..
//

import SwiftUI

struct Expander<Content>: View where Content: View {
    let content: () -> Content
    let title: String
    @State var isOpen = false

    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.title = title
    }

    var body: some View {
        VStack {
            Button(action: {
                isOpen = !isOpen
            }, label:{
                HStack {
                    BasicText(text: title, size: 18)
                    Spacer()
                    if isOpen {
                        Image("shrinkIcon")
                            .resizable()
                            .frame(width: 14, height: 7)
                    } else {
                        Image("expandIcon")
                            .resizable()
                            .frame(width: 14, height: 7)
                    }
                }
            })
            if isOpen {
                content()
            }
        }
    }
}
