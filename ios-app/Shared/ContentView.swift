//
//  ContentView.swift
//  Shared
//
//  Created by alex slobodeniuk on 15.02.2022.
//

import SwiftUI
import AuthenticationServices

enum NavigationPages: Hashable {
    case consent, login, tutorial, firstRun, connection, mainPage, settings
}

struct ContentView: View {
    @AppStorage("launchedBefore") var launchedBefore: Bool = false
    @EnvironmentObject var data: ConsentState
    @AppStorage("hadConnectionsBefore") var hadConnectionsBefore: Bool = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var core: MeeAgentStore
    @State var appWasMinimized: Bool = true
    
    @EnvironmentObject private var navigationState: NavigationState
    @EnvironmentObject private var appState: AppState
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var viewModel = NavigationViewModel()
    
    func setUnlocked(result: Bool) {
        print("unlocked: ", result)
        appWasMinimized = !result
    }
    
    func tryAuthenticate() {
        requestLocalAuthentication(setUnlocked)
    }
    
    var body: some View {
        ZStack {
            Group {
                NavigationPage(isLocked: appWasMinimized)
            }
            
        }
        .overlay {
            FadedLoading()
                .opacity((viewModel.isLoading) ? 1 : 0)
        }
        .overlay {
            ZStack {
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black.opacity(0.4))
            .opacity(appState.isSlideMenuOpened ? 1 : 0)
            .onTapGesture(count: 1) {
                withAnimation() {
                    viewModel.toggleMenu(false)
                }
            }
        }
        .overlay {
            if (appState.isSlideMenuOpened) {
                SideMenu() {
                    viewModel.toggleMenu(false)
                }
                .transition(.move(edge: .leading))
            }
        }
        
        .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.width < -20 {
                    withAnimation {
                        viewModel.toggleMenu(false)
                    }
                }
                
                if value.translation.width > 20 {
                    withAnimation {
                        viewModel.toggleMenu(true)
                    }
                }
            }))
        .overlay{
            LoginPage()
                .opacity((launchedBefore && appWasMinimized) ? 1 : 0)
        }
        .font(Font.custom("PublicSans-Regular", size: 16))
        .onAppear {
            viewModel.setup(appState: appState,
                            core: core,
                            consentState: data,
                            launchedBefore: launchedBefore,
                            hadConnectionsBefore: hadConnectionsBefore,
                            navigationState: navigationState
            )
        }
        .onChange(of: launchedBefore) {_ in
            tryAuthenticate()
        }
        .onChange(of: scenePhase) { newPhase in
            switch (newPhase) {
            case .background:
                print("background")
                scheduleAppRefresh()
                if (navigationState.currentPage == .consent) {
                    navigationState.currentPage = .mainPage
                }
                appWasMinimized = true
                
            case .active:
                print("active")
                if appWasMinimized && launchedBefore {
                    tryAuthenticate()
                }
            case .inactive:
                print("inactive")
            @unknown default:
                break;
            }
        }
        .onOpenURL { url in
            viewModel.processUrl(url: url)
        }
        .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
            guard let url = userActivity.webpageURL else {
                return
            }
            viewModel.processUrl(url: url)
        }
        .toastView(toast: $appState.toast)
        
    }
}
