//
//  TutorialPage.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 28.3.23..
//

import SwiftUI

struct TutorialPage: View {
    @EnvironmentObject private var navigationState: NavigationState
    var body: some View {
        TourPage(images: ["meeWelcome1", "meeWelcome2"]) {
            navigationState.currentPage = .mainViewPage
        }
    }
}

