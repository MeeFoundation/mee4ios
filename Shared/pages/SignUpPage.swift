//
//  SignIn.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 19.02.2022.
//

import SwiftUI

struct SignUpPage: View {
    @State var signupForm = SignupForm()
    @State var signupFormError = SignupFormState()
    
    func checkSignupFormProfileError() -> Bool {
        if signupForm.firstName?.range(of: firstNameValidationString, options:.regularExpression) == nil { signupFormError.firstName = "First Name should be at least 2 symbols" }
        if signupForm.firstName == nil { signupFormError.firstName = "Please enter First Name" }
        return signupFormError.firstName == nil
    }
    
    func checkSignupFormUserdataError() -> Bool {
        signupFormError = SignupFormState()
        if signupForm.passwordRepeat != signupForm.password { signupFormError.passwordRepeat = "Passwords must match" }
        if signupForm.email?.range(of: emailValidationString, options:.regularExpression) == nil { signupFormError.email = "Please enter correct email" }
        if signupForm.userName?.range(of: usernameValidationString, options:.regularExpression) == nil { signupFormError.userName = "Username should be at least 2 symbols" }
        if signupForm.password?.range(of: passwordValidationString, options:.regularExpression) == nil { signupFormError.password = "Password should be at least 2 symbols" }
        if signupForm.userName == nil { signupFormError.userName = "Please enter username" }
        if signupForm.email == nil { signupFormError.email = "Please enter email" }
        if signupForm.password == nil { signupFormError.password = "Please enter password" }

        
        return signupFormError.userName == nil &&
                signupFormError.email == nil &&
                signupFormError.password == nil &&
                signupFormError.passwordRepeat == nil
    }
        var body: some View {
            ZStack {
                Background()
                
                VStack {
                    Image("meeLogo").resizable().scaledToFit().padding(.horizontal, 50.0).padding(.bottom, 20.0).padding(.top, 50.0)
                    ScrollView {
                        Group {
                        switch (signupForm.step) {
                        case 0: Group {
                                Group {
                                    InputView("Username", text: $signupForm.userName, error: $signupFormError.userName)
                                }
                                Group {
                                    InputView("Email", text: $signupForm.email, error: $signupFormError.email)
                                }
                                Group {
                                    SecureInputView("Password", text: $signupForm.password, error: $signupFormError.password ,showAdditionalIcons: true)
                                }
                                Group {
                                    SecureInputView("Repeat Password", text: $signupForm.passwordRepeat, error: $signupFormError.passwordRepeat)
                                }
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
                                InputView("First Name", text: $signupForm.firstName, error: $signupFormError.firstName)
                            }
                            .padding(.top, 15.0)
                            .padding(.bottom, 20.0)
                            BasicText(text: "Please select profile image:")
                                .padding(.bottom, 30.0)
                            LibraryImage(uiImage: $signupForm.image)
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
                        }.padding(.horizontal, 5.0)
                }
                    Spacer()
                    HStack {
                        if (signupForm.step > 0 && signupForm.step < 3) {
                            MainButton("Back", action: {signupForm.step-=1})
                        }
                        if (signupForm.step < 3) {
                            MainButton("Next", action: {
                                switch (signupForm.step) {
                                case 0:
                                    if checkSignupFormUserdataError() {
                                        signupForm.step+=1
                                    }
                                case 2:
                                    if checkSignupFormProfileError() {
                                        signupForm.step+=1
                                    }
                                default:
                                    signupForm.step+=1
                                }
                                
                            })
                        }
                        if (signupForm.step == 3) {
                            MainButton("Finish", action: {
                                
                            })
                        }
                    }
                    
                }
                .padding(.horizontal, 20)
            }
        }
}

