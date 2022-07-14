//
//  Background.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 18.02.2022.
//

import SwiftUI

struct Background: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Colors.background)
            .edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundFaded: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color.black.opacity(0.4))
            .edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundColor: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Colors.meeBrand)
            .edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundWhite: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color.white)
            .edgesIgnoringSafeArea(.all)
    }
}
