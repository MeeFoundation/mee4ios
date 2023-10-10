//
//  AllSetDialog.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 3.10.23..
//

import SwiftUI

struct UnrecoverableErrorDialog: View {
    
    let displayError: DisplayErrorType?
    
    init(error: AppErrorRepresentation?) {
        if let error {
            displayError = DisplayErrorType(error)
        } else {
            displayError = nil
        }
        
    }
    
    
    var body: some View {
        if let displayError {
            ZStack {
                VStack {
                    Image(displayError.imageName).resizable()
                        .frame(width: 60.5, height: 60.5, alignment: .center)
                        .padding(.top, 14)
                        .zIndex(10)
                    Text(displayError.text).font(Font.custom(FontNameManager.PublicSans.bold, size: 34))
                        .foregroundColor(Colors.text)
                        .padding(.bottom, 8)
                        .padding(.horizontal, 16)
                        .multilineTextAlignment(.center)
                    Text(displayError.description)
                        .foregroundColor(Colors.text)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    if let secondaryActionName = displayError.secondaryActionName, let onSecondaryAction = displayError.onSecondaryAction  {
                        RejectButton(secondaryActionName, action: onSecondaryAction, fullWidth: true, isTransparent: true)
                    }
                    
                    SecondaryButton(displayError.primaryActionName, action: displayError.onPrimaryAction, fullWidth: true)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 65)
                    
                }
                .frame(maxWidth: .infinity)
            }
            .background(Colors.popupBackground)
            .cornerRadius(10)
        } else {
            ZStack {}
        }
        
    }
}
