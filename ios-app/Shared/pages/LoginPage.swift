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
        NavigationView {
            ZStack {
                BackgroundFaded()
                VStack {
                    ZStack {
                        Image("meeLogoInactive")
                            .resizable()
                            .scaledToFit()
                    }
                    .padding(.horizontal, sizeClass == .compact ? 115.0 : 330).padding(.top,  sizeClass == .compact ? 35.0 : 150)
//                    Group {
//                        InputView("Username", text: $loginForm.username)
//                    }
//                    .padding(.top, 15.0)
//                    .padding(.bottom, 20.0)
//                    Group {
//                        SecureInputView("Password", text: $loginForm.password)
//                    }
//                    .padding(.top, 15.0)
                    Spacer()
//                    HStack {
//                        MainButton("Login", action: {})
//                        NavigationLink(
//                            destination: SignUpPage()
//                            ,tag: NavigationPages.signUp
//                            ,selection: $navigationState.currentPage
//                        ) {
//                            SecondaryButton("Sign Up", action: {
//                                navigationState.currentPage = NavigationPages.signUp
//                            })
//                        }
//                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
}
