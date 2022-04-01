//
//  Popup.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 22.03.2022.
//

import Foundation
import SwiftUI

struct PopupWindow<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    let presenting: () -> Presenting
    
    let text: Text

    var body: some View {

        GeometryReader { geometry in
            
            ZStack(alignment: .center) {

                self.presenting()
                    .blur(radius: self.isShowing ? 1 : 0)

                VStack {
                    self.text
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 10)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .transition(.slide)
                .opacity(self.isShowing ? 1 : 0)

            }

        }

    }
}
