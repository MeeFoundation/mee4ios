//
//  FirstRunIntroPage.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 12.4.23..
//

import SwiftUI

struct FirstRunPageIntro: View {
    @Environment(\.openURL) var openURL
    @AppStorage("launchedBefore") var launchedBefore: Bool = false
    @EnvironmentObject private var navigationState: NavigationState
    let installedUrl = URL(string: "https://auth.mee.foundation/installed")
    
    var body: some View {
        TourPage(images: ["meeFirstRun1", "meeFirstRun2"]) {
            if let installedUrl {
                launchedBefore = true
                openURL(installedUrl)
            }
        }

    }
}

struct FirstRunPageIntroAlt: View {
    @Environment(\.openURL) var openURL
    @AppStorage("launchedBefore") var launchedBefore: Bool = false
    @EnvironmentObject private var navigationState: NavigationState
    
    var body: some View {
        TourPage(images: ["meeFirstRun1", "meeWelcome2"]) {
            launchedBefore = true
            navigationState.currentPage = .consent
        }
        
    }
}
