//
//  EmptyAppPage.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 12.7.22..
//

import SwiftUI

struct EmptyAppPage: View {
    func createPassphrase() {
    
    }
    func recoverData() {
    
    }
    var body: some View {

            ZStack {
                VStack {
                    ZStack {
                        Image("meeLogo").resizable().scaledToFit()
                    }
                    .padding(.horizontal, 115.0)
                    .padding(.top, 35.0)
                    .padding(.bottom, 48)
                    ZStack {
                        BasicText(text:"This Mee Smartwallet app holds personal data about you and protects it using your phone's faceID. However, if all of your devices are ever lost, as well as backup access, you will need to enter a passphrase to recover your personal data.", size: 16)
                    }.padding(.horizontal, 16)
                    SecondaryButton("Create Recovery Passphrase", action: createPassphrase, fullWidth: true)
                        .padding(.horizontal, 33)
                        .padding(.top, 71)
                    LinkButton("Recover Your Data", action: recoverData)
                        .padding(.top, 24)
                    Spacer()
                    HStack {
                        Image("infoIcon").resizable().scaledToFit().frame(width: 24, height: 24, alignment: .center)
                        BasicText(text:"How to use Mee Smartwallet app?", fontName: FontNameManager.PublicSans.medium)
                    }.padding(.bottom, 73)
                  
                     
                }
                .ignoresSafeArea(edges: .bottom)
            }
        
    }
}
