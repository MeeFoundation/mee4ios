//
//  SignIn.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 19.02.2022.
//

import SwiftUI

struct LoginPage: View {
    @State var userName = ""
    @State var password = ""
    var body: some View {
        ZStack {
            Background()
            VStack {
                Image("meeLogo").resizable().scaledToFit().padding(.horizontal, 50.0).padding(.bottom, 20.0).padding(.top, 50.0)
                Group {
                    InputView("Username", text: $userName)
                }
                .padding(.top, 15.0)
                .padding(.bottom, 20.0)
                Group {
                    SecureInputView("Password", text: $password)
                }
                .padding(.top, 15.0)
                Spacer()
                HStack {
                    MainButton("Login", action: {})
                    SecondaryButton("Sign Up", action: {})
                }
            }
            .padding(.horizontal, 50.0)
        }
    }
    
}
