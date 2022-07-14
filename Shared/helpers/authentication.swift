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
//    let nowDate = Date()
//    let df = DateFormatter()
//    df.dateFormat = "yyyy-MM-dd hh:mm:ss"
//    let keychain = Keychain(service: "mee-ios-client", accessGroup: "4UGU9PNWK8.com.swift.mee-ios-client.config").synchronizable(true)
//    let validationDate = df.date(from: keychain["validationDate"] ?? "")
    let context = LAContext()
    var error: NSError?

    if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
        let reason = "We need to unlock your data"
        context.localizedCancelTitle = "Cancel"
        context.localizedFallbackTitle = "Use device password"
//        print(validationDate, nowDate, nowDate < validationDate!)
//        if validationDate != nil && nowDate < validationDate! {
//            completion(true)
//            return
//        }

        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
            if success {
                completion(true)
//                let nowString = df.string(from: Date() + 1 * 60 * 60)
//                print(nowString)
//                keychain["validationDate"] = nowString
                print("authentication successfull")
            } else {
                completion(false)
                print("authentication failed")
            }
        }
    } else {
        completion(false)
        print("biometrics unavailable")
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
