//
//  Errors.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 5.10.23..
//

func errorToAppError(_ e: Error) -> AppError {
    if let e = e as? MeeErr {
        return AppError.CoreError(e)
    } else if let e = e as? AppError {
        return e
    } else {
        return AppError.UnknownError
    }
}

enum AppError: Error {
    case CoreError(MeeErr)
    case KeychainError
    case UnknownError
}

enum AppAction {
    case initialization
    case userDataRemoving
}

struct DisplayErrorType {
    let imageName: String
    let text: String
    let description: String
    let primaryActionName: String
    let secondaryActionName: String?
    let onPrimaryAction: () -> Void
    let onSecondaryAction: (() -> Void)?
    
    init(_ e: AppErrorRepresentation) {
        switch(e.error) {
        case .CoreError(let coreError):
            switch(coreError) {
            case .MeeStorage(let meeStorageError):
                switch(meeStorageError) {
                case .AppLevelMigration(_):
                    self = migrationError
                default:
                    switch (e.action) {
                    case .userDataRemoving:
                        self = userdataRemoveError
                    default:
                        self = unknownError
                    }
                    
                }
            case .MeeConnectors(let meeConnectorsError):
                switch(meeConnectorsError) {
                default:
                    self = unknownError
                }
            case .MeeCrypto(let meeCryptoError):
                switch(meeCryptoError) {
                default:
                    self = unknownError
                }
            case .MeeDid(let meeDidError):
                switch(meeDidError) {
                default:
                    self = unknownError
                }
            case .MeeInternals(let meeInternalsError):
                switch(meeInternalsError) {
                default:
                    self = unknownError
                }
            case .MeeOidc(let meeOidcError):
                switch(meeOidcError) {
                default:
                    self = unknownError
                }
            
            case .NativeCapabilities(error: _):
                self = unknownError
            }
        case .KeychainError:
            self = unknownError
            
        case .UnknownError:
            self = unknownError
            
        }

    }
    init(imageName: String,
         text: String,
         description: String,
         primaryActionName: String,
         onPrimaryAction: @escaping () -> Void,
         secondaryActionName: String? = nil,
         onSecondaryAction: (() -> Void)? = nil
    ) {
        self.imageName = imageName
        self.text = text
        self.description = description
        self.primaryActionName = primaryActionName
        self.secondaryActionName = secondaryActionName
        self.onPrimaryAction = onPrimaryAction
        self.onSecondaryAction = onSecondaryAction
    }
}

let migrationError =
DisplayErrorType(imageName: "errorIcon",
                 text: "Error occurred migrating user data",
                 description: "We are unable to recover your data. To handle the failed migration, it is necessary to completely reset the user data. Please go to the system settings and delete your data to resolve the issue.",
                 primaryActionName: "Go to System Settings",
                 onPrimaryAction: openSettingsUrl)

let userdataRemoveError =
DisplayErrorType(imageName: "errorIcon",
                 text: "Error occurred deleting user data",
                 description: "We were unable to delete your data. To resolve this issue, please go to the system settings to manually delete your data.",
                 primaryActionName: "Go to System Settings",
                 onPrimaryAction: openSettingsUrl,
                 secondaryActionName: "Send Feedback",
                 onSecondaryAction: openFeedbackUrl)

let unknownError =
DisplayErrorType(imageName: "errorIcon",
                 text: "Unknown error occured",
                 description: "We are unable to recover your data. To resovle the issue, please go to the system settings and manually delete your data or contact us if problem persists.",
                 primaryActionName: "Go to System Settings",
                 onPrimaryAction: openSettingsUrl,
                 secondaryActionName: "Send Feedback",
                 onSecondaryAction: openFeedbackUrl)
