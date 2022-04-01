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
    var body: some View {
        NavigationView {
            ZStack {
                Background()
                VStack {
                    Image("meeLogo").resizable().scaledToFit().padding(.horizontal, 50.0).padding(.bottom, 20.0).padding(.top, 50.0)
                    Group {
                        InputView("Username", text: $loginForm.username)
                    }
                    .padding(.top, 15.0)
                    .padding(.bottom, 20.0)
                    Group {
                        SecureInputView("Password", text: $loginForm.password)
                    }
                    .padding(.top, 15.0)
                    Spacer()
                    HStack {
                        MainButton("Login", action: {})
                        NavigationLink(
                            destination: SignUpPage()
                            ,tag: NavigationPages.signUp
                            ,selection: $navigationState.currentPage
                        ) {
                            SecondaryButton("Sign Up", action: {
                                navigationState.currentPage = NavigationPages.signUp
                            })
                        }
                    }
                }
                .padding(.horizontal, 50.0)
            }
        }
    }
    
}
