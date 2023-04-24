//
//  SignIn.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 19.02.2022.
//

import SwiftUI

struct LoginPage: View {
    @State var loginForm = LoginForm()
    @EnvironmentObject private var navigationState: NavigationState
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        ZStack {
            Background()
            BackgroundFaded()
            VStack {
                ZStack {
                    Image("meeLogoInactive")
                        .resizable()
                        .scaledToFit()
                }
                .padding(.horizontal, sizeClass == .compact ? 115.0 : 330).padding(.top,  sizeClass == .compact ? 35.0 : 150)
                
                Spacer()
                
            }
        }
    }
    
}
