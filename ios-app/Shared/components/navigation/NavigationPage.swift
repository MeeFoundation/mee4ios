//
//  NavigationPage.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 19.4.23..
//

import SwiftUI

struct NavigationPage: View {
    var isLocked: Bool
    @State var tutorialViewed: Bool = false
    @AppStorage("hadConnectionsBefore") var hadConnectionsBefore: Bool = false
    @EnvironmentObject private var navigationState: NavigationState
    @AppStorage("launchedBefore") var launchedBefore: Bool = false


    var body: some View {
        ZStack {
            Background()
            VStack {
                NavigationLink(
                    "Consent",
                    destination: ConsentPage(isLocked: isLocked)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                    ,tag: NavigationPages.consent
                    ,selection: $navigationState.currentPage
                )
                
                NavigationLink(
                    "Main",
                    destination: MainViewPage()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                    ,tag: NavigationPages.mainViewPage
                    ,selection: $navigationState.currentPage
                )
                
                NavigationLink(
                    "Tutorial",
                    destination: TutorialPage()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                    ,tag: NavigationPages.tutorial
                    ,selection: $navigationState.currentPage
                )
                
                NavigationLink(
                    "FirstRun",
                    destination: FirstRunPage()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                    ,tag: NavigationPages.firstRun
                    ,selection: $navigationState.currentPage
                )
            }
        }
        .onChange(of: launchedBefore) { newValue in
            if newValue {
                navigationState.currentPage = .mainViewPage
            }
        }
        .onAppear {
            if (!launchedBefore) {
                navigationState.currentPage = .firstRun
            }
            else if (!tutorialViewed && navigationState.currentPage == .mainViewPage) {
                if !hadConnectionsBefore {
                    navigationState.currentPage = .tutorial
                }
                tutorialViewed = true
            }
        }
    }
}
