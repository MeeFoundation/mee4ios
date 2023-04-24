//
//  FirstRun.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 08.07.2022.
//

import SwiftUI

enum FirstRunPages: Hashable {
    case prepare, faceId, faceIdSet, initializing, intro
}


struct FirstRunPage: View {
    @State private var currentPage = FirstRunPages.prepare
    @AppStorage("launchedBefore") var launchedBefore: Bool = false
    @EnvironmentObject var data: ConsentState
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.openURL) var openURL
    @EnvironmentObject private var navigationState: NavigationState
    
    func tryAuthenticate() {
        currentPage = FirstRunPages.faceId
        requestLocalAuthentication({result in
            if !result {
                currentPage = FirstRunPages.prepare
            } else {
                currentPage = FirstRunPages.faceIdSet
            }
        })
    }
    
    func startInitializing() {
        currentPage = FirstRunPages.initializing
    }
    
    func finishInitializing() {
        print("data.consent.id: ", data.consent.id)
        if data.consent.id.isEmpty {
            currentPage = .intro
        } else {
            launchedBefore = true
            navigationState.currentPage = .consent
        }
        
        
    }
    
    var body: some View {
        ZStack {
            if currentPage == FirstRunPages.initializing {
                ZStack {
                    FirstRunPageInitializing(onNext: finishInitializing)
                }.background(Colors.background)
            } else if currentPage == .intro {
                FirsRunPageIntro()
            } else {
                ZStack {
                    BackgroundFaded()
                    VStack {
                        ZStack {
                            Image("meeLogoInactive")
                                .resizable()
                                .scaledToFit()
                        }
                        .padding(.horizontal, sizeClass == .compact ? 115.0 : 330).padding(.top,  sizeClass == .compact ? 35.0 : 150)
                        Spacer()
                        if currentPage == FirstRunPages.prepare {FirstRunPagePrepare(onNext: tryAuthenticate)}
                        if currentPage == FirstRunPages.faceIdSet {FirstRunPageFaceIdSet(onNext: startInitializing
                        )}
                        
                    }
                    .ignoresSafeArea(edges: .bottom)
                }}
        }
    }
    
}

struct FirstRunPagePrepare: View {
    var onNext: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                Image("faceId").resizable()
                    .frame(width: 60.5, height: 60.5, alignment: .center)
                    .padding(.top, 14)
                    .zIndex(10)
                Text("Set up \(biometricsTypeText)").font(Font.custom(FontNameManager.PublicSans.bold, size: 34))
                    .foregroundColor(Colors.text)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                
                Text("Mee uses \(biometricsTypeText) to make sure that you are the only person who can open the app.")
                    .foregroundColor(Colors.text)
                    .font(.custom(FontNameManager.PublicSans.regular , size: 18))
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 64)
                MainButton("Continue", action: onNext, fullWidth: true)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 65)
                
            }
            .frame(maxWidth: .infinity)
        }
        .background(Colors.popupBackground)
        .cornerRadius(10)
    }
}

struct FirstRunPageFaceIdSet: View {
    var onNext: () -> Void
    var body: some View {
        ZStack {
            VStack {
                Image("greenCheckmark").resizable()
                    .frame(width: 60.5, height: 60.5, alignment: .center)
                    .padding(.top, 14)
                    .zIndex(10)
                Text("All Set!").font(Font.custom(FontNameManager.PublicSans.bold, size: 34))
                    .foregroundColor(Colors.text)
                    .lineSpacing(41)
                    .padding(.bottom, 8)
                Text("Use \(biometricsTypeText) next time you sign-in")
                    .foregroundColor(Colors.text)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center).padding(.horizontal, 60)
                    .padding(.bottom, 64)
                MainButton("Continue", action: onNext, fullWidth: true)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 65)
                
            }
            .frame(maxWidth: .infinity)
        }
        .background(Colors.popupBackground)
        .cornerRadius(10)
    }
}

struct FirstRunPageInitializing: View {
    var onNext: () -> Void
    @State private var state = FirstRunPageInitializingState()
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                ZStack {
                    Image("mLogo").resizable()
                        .scaledToFit()
                        .frame(width: !state.finalAnimation ? 103.26 : 103.26 * state.animationMultiplier, height: !state.finalAnimation ? 71.61 : 71.61 * state.animationMultiplier, alignment: .center)
                        .transition(.scale)
                        .zIndex(10)
                        .padding(.vertical, 50)
                        .padding(.horizontal, 37)
                    
                    LoadingCircle(progress: state.progress, width: !state.finalAnimation ? 171 : 171 * state.animationMultiplier, height: !state.finalAnimation ? 171 : 171 * state.animationMultiplier)
                }
                .transition(.scale)
                .animation(Animation.linear(duration: 2), value: state.finalAnimation)
                .background(Colors.meeBrand)
                .cornerRadius(3)
                ZStack {
                    Text(state.text)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Colors.text)
                        .font(.custom(FontNameManager.PublicSans.medium , size: 18))
                        .multilineTextAlignment(.center)
                }
                .frame(minHeight: 42)
                .padding(.top, 15)
                .padding(.bottom, 150)
                .frame(width:  220)
                
                Spacer()
            }
            .onReceive(timer) { time in
                if state.progress >= 1.5 {
                    timer.upstream.connect().cancel()
                    onNext()
                }
                if state.progress >= 1 {
                    withAnimation {
                        state.finalAnimation = true
                    }
                    //                             onNext()
                } else if state.progress < 0.1 {
                    state.text = "Generating unique device keys"
                } else if state.progress < 0.4 {
                    state.text = "Generating context data encryption key"
                } else if state.progress < 0.7 {
                    state.text = "Generating context-specific user indentifier"
                } else if state.progress < 0.9 {
                    state.text = "Creating Self in the Mee data storage"
                } else {
                    state.text = ""
                }
                
                state.progress += 0.02
            }
            .frame(maxWidth: .infinity)
            .opacity(state.finalAnimation ? 0 : 1)
            .animation(Animation.linear(duration: 2), value: state.finalAnimation)
            .background(state.finalAnimation ? Colors.meeBrand : nil)
        }
    }
}
