//
//  authentication.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 21.03.2022.
//

import Foundation
import LocalAuthentication
import KeychainAccess

func requestLocalAuthentication (_ completion: @escaping ((Bool) -> ())) {
    let context = LAContext()
    var error: NSError?

    if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
        let reason = "We need to unlock your data"
        context.localizedCancelTitle = "Cancel"
        context.localizedFallbackTitle = "Use device password"

        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    } else {
        completion(false)
    }
}

func biometricType() -> BiometricType {
    let authContext = LAContext()
    if #available(iOS 11, *) {
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch(authContext.biometryType) {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        default:
            return .none
        }
    } else {
        return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
    }
}

let biometricsTypeText = biometricType() == .touch ? "Touch ID" : biometricType() == .face ? "Face ID" : "passcode"

enum BiometricType {
    case none
    case touch
    case face
}
