//
//  FirstRunIntroPage.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 12.4.23..
//

import SwiftUI

struct FirsRunPageIntro: View {
    @Environment(\.openURL) var openURL
    @AppStorage("launchedBefore") var launchedBefore: Bool = false
    let installedUrl = URL(string: "https://auth.mee.foundation/#/installed")
    
    var body: some View {
        TourPage(images: ["meeFitstRun1", "meeFitstRun2"]) {
            if let installedUrl {
                launchedBefore = true
                openURL(installedUrl)
            }
        }

    }
}
