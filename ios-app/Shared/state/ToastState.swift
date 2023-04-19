//
//  ToastState.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 17.4.23..
//

import Foundation

class ToastState: ObservableObject {
    @Published var toast: ToastMessage? = nil
}
