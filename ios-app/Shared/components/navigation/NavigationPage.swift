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
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NavigationView {
            
            VStack {
                NavigationLink(
                    destination: MainViewPage()
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                    ,tag: NavigationPages.mainPage
                    ,selection: $navigationState.currentPage
                ) {EmptyView()}
                
                NavigationLink(
                    destination: ConsentPage(isLocked: isLocked)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                    ,tag: NavigationPages.consent
                    ,selection: $navigationState.currentPage
                ) {EmptyView()}
                
                NavigationLink(
                    destination: TutorialPage()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                    ,tag: NavigationPages.tutorial
                    ,selection: $navigationState.currentPage
                ){EmptyView()}
                
                NavigationLink(
                    destination: FirstRunPage()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                    ,tag: NavigationPages.firstRun
                    ,selection: $navigationState.currentPage
                ){EmptyView()}
                
            }
        }
        .navigationViewStyle(.stack)
        .onChange(of: navigationState.currentPage) { newPage in
            print("navigate: ", newPage)
        }
        .onChange(of: launchedBefore) { newValue in
            if newValue && navigationState.currentPage == .firstRun {
                tutorialViewed = true
                navigationState.currentPage = .tutorial
            }
        }
        .onAppear {
            if (!launchedBefore) {
                navigationState.currentPage = .firstRun
            }
            else if (!tutorialViewed && navigationState.currentPage == .mainPage) {
                if !hadConnectionsBefore {
                    tutorialViewed = true
                    navigationState.currentPage = .tutorial
                }
                
            }
        }
    }
}
