//
//  SignIn.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 19.02.2022.
//

import SwiftUI

struct SignUpPage: View {
        @State var step = 0
        @State var userName = ""
        @State var email = ""
        @State var password = ""
        @State var passwordRepeat = ""
        @State var firstName = ""
        var body: some View {
            ZStack {
                Background()
                VStack {
                    Image("meeLogo").resizable().scaledToFit().padding(.horizontal, 50.0).padding(.bottom, 20.0).padding(.top, 50.0)
                    switch (step) {
                    case 0: Group {
                            Group {
                                InputView("Username", text: $userName)
                            }
                            .padding(.top, 15.0)
                            .padding(.bottom, 20.0)
                            Group {
                                InputView("Email", text: $email)
                            }
                            .padding(.top, 15.0)
                            .padding(.bottom, 20.0)
                            Group {
                                SecureInputView("Password", text: $password)
                            }
                            .padding(.top, 15.0)
                            .padding(.bottom, 20.0)
                            Group {
                                SecureInputView("Repeat Password", text: $passwordRepeat)
                            }
                            .padding(.top, 15.0)
                            .padding(.bottom, 20.0)
                            Spacer()
                        }
                    case 1: Group{
                        Image(systemName: "folder.fill")
                            .resizable()
                            .foregroundColor(Colors.mainButtonColor)
                            .scaledToFit()
                            .padding(.horizontal, 70.0)
                            .padding(.top, 100)
                        SecondaryButton("Download keys", action: {
                          
                        })
                            
                    }
                    case 2: Group{
                        Group {
                            InputView("First Name", text: $firstName)
                        }
                        .padding(.top, 15.0)
                        .padding(.bottom, 20.0)
                        BasicText(text: "Please select profile image:")
                            .padding(.bottom, 30.0)
                        LibraryImage()
                    }
                    case 3: Group{
                        BasicText(text: "Your account was created")
                        Image("appQrCode")
                            .resizable()
                            .scaledToFit()
                        SecondaryButton("MEE Tutorial", action: {})
                    }
                    default: Group{
                        Text("Default")
                    }
                    }
                    Spacer()
                    HStack {
                        if (step > 0 && step < 3) {
                            MainButton("Back", action: {step-=1})
                        }
                        if (step < 3) {
                            MainButton("Next", action: {step+=1})
                        }
                        if (step == 3) {
                            MainButton("Finish", action: {})
                        }
                    }
                }
                .padding(.horizontal, 50.0)
            }
        }
}

struct Previews_SignUpPage_Previews: PreviewProvider {
    static var previews: some View {
        SignUpPage()
    }
}
