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
    @State private var menuDragOffset: CGSize = .zero
    
    @EnvironmentObject private var navigationState: NavigationState
    @EnvironmentObject private var appState: AppState
    @Environment(\.scenePhase) var scenePhase
    @State var isDraggingRight: Bool = false
    @StateObject private var viewModel = NavigationViewModel()
    let minimumDragDistance: CGFloat = 100
    
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
                .offset(x: menuDragOffset.width)
            }
        }
        .gesture(DragGesture(coordinateSpace: .local)
            .onChanged { value in
                isDraggingRight = value.translation.width > 0 && value.startLocation.x == 0
                if isDraggingRight {
                    menuDragOffset = CGSize(width: (value.translation.width - 320) > 0 ? 0 : (value.translation.width - 320), height: 0)
                    if !appState.isSlideMenuOpened && value.translation.width > minimumDragDistance {
                        viewModel.toggleMenu(true)
                    }
                } else {
                    menuDragOffset = CGSize(width: value.translation.width > 0 ? 0 : value.translation.width, height: 0)
                }
            }
            .onEnded({ value in
                withAnimation {
                    if value.translation.width < -minimumDragDistance {
                        viewModel.toggleMenu(false)
                    } else if value.translation.width > minimumDragDistance {
                        viewModel.toggleMenu(true)
                    }
                    menuDragOffset = .zero
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
        .onChange(of: launchedBefore) {lb in
            tryAuthenticate()
            viewModel.changeLaunchedBefore(lb)
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
            Task {
                await viewModel.processUrl(url: url)
            }
            
        }
        .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
            guard let url = userActivity.webpageURL else {
                return
            }
            Task {
                await viewModel.processUrl(url: url)
            }
            
        }
        .toastView(toast: $appState.toast)
        
    }
}
