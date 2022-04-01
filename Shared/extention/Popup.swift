//
//  Popup.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 22.03.2022.
//

import Foundation
import SwiftUI

extension View {

    func popup(isShowing: Binding<Bool>, text: Text) -> some View {
        PopupWindow(isShowing: isShowing,
              presenting: { self },
              text: text)
    }

}
