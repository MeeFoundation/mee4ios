//
//  FadedLoading.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 9.6.23..
//

import SwiftUI

struct FadedLoading: View {
    var body: some View {
            ZStack {
                BackgroundFaded()
                VStack {
                    ZStack {
                        ProgressView()
                        Spacer()
                    }
                }
            }
    }
}
