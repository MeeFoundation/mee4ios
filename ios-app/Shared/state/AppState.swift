//
//  AppState.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 17.4.23..
//

import Foundation

class AppState: ObservableObject {
    @Published var toast: ToastMessage? = nil
    @Published var isSlideMenuOpened: Bool = false
}
