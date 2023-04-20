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
            
            VStack {
                MainViewPage()
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
                
                NavigationLink(
                    destination: PartnerDetails(requestId: navigationState.payload),
                    tag: NavigationPages.connection,
                    selection: $navigationState.currentPage
                ){EmptyView()}
            }
        }
        .onChange(of: launchedBefore) { newValue in
            if newValue {
                navigationState.currentPage = nil
            }
        }
        .onAppear {
            if (!launchedBefore) {
                navigationState.currentPage = .firstRun
            }
            else if (!tutorialViewed && navigationState.currentPage == nil) {
                if !hadConnectionsBefore {
                    navigationState.currentPage = .tutorial
                }
                tutorialViewed = true
            }
        }
    }
}
