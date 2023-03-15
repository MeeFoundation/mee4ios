//
//  Introduction.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 9.3.23..
//

import SwiftUI

struct IntroductionPopup: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Image("meeLogo").resizable().scaledToFit().padding(.horizontal, 70)
                    .padding(.bottom, 70)
                BasicText(text: "Welcome to Mee Identity Agent", color: Colors.meeBrand, size: 23, fontName: FontNameManager.PublicSans.bold, weight: .bold)
                    .padding(.bottom, 20)
                BasicText(text: "Let’s set up your first connection to put you in control of your online identity.", color: Colors.meeBrand, size: 23, fontName: FontNameManager.PublicSans.regular, weight: .regular)
                    .padding(.bottom, 50)
                BasicText(text: "Please start the Connect-with-Mee flow from the Mee-compatible partner website.", color: Colors.meeBrand, size: 14, fontName: FontNameManager.PublicSans.regular, weight: .regular)
                Spacer()
            }
            .padding(.horizontal, 40)
        }
    }
}

