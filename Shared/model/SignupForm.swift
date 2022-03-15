//
//  SignupForm.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 01.03.2022.
//

import Foundation
import UIKit


struct SignupForm {
    var step = 0
    var userName: String? = nil
    var email: String? = nil
    var password: String? = nil
    var passwordRepeat: String? = nil
    var firstName: String? = nil
    var image: UIImage? = nil
}

struct SignupFormState {
    var userName: String? = nil
    var email: String? = nil
    var password: String? = nil
    var passwordRepeat: String? = nil
    var firstName: String? = nil
}
