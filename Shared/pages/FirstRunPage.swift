//
//  FirstRun.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 08.07.2022.
//

import SwiftUI

enum FirstRunPages: Hashable {
    case welcome, prepare, faceId, faceIdSet, initializing
}


struct FirstRunPage: View {
    @AppStorage("launchedBefore") var launchedBefore: Bool = false
    @State private var currentPage = FirstRunPages.welcome
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.openURL) var openURL
    
    let installedUrl = URL(string: "https://www-dev.meeproject.org/#/installed")
    
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
        launchedBefore = true
        if let installedUrl {
            openURL(installedUrl)
        }
        
    }
    
    var body: some View {
        ZStack {
            if currentPage == FirstRunPages.initializing {
                ZStack {
                    FirstRunPageInitializing(onNext: finishInitializing)
                }.background(Colors.background)
            } else if currentPage == FirstRunPages.welcome {
                FirstRunPageWelcome(onNext: {currentPage = FirstRunPages.prepare})
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

struct FirstRunPageWelcome: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    var onNext: () -> Void
    var isInitialization: Bool? = false
    var body: some View {
        ZStack {
            BackgroundYellow()
            VStack(spacing: 0) {
                Image("meeEntry").resizable().scaledToFit()
                    .overlay(VStack(spacing: 0) {
//                        HStack {
//                            BasicText(text:"Hello. ", color: Colors.textYellow, size: sizeClass == .compact ? 30 : 40, fontName: FontNameManager.PublicSans.bold)
//                            BasicText(text:"It’s Mee.", color: Colors.meeBrand, size: sizeClass == .compact ? 30 : 40, fontName: FontNameManager.PublicSans.regularItalic)
//                        }
//                        if isInitialization! {
//                            BasicText(text:"I invite you to join a journey to your digital self. I will be your twin in the digital world. Don’t worry, I know nothing about you yet, but I will learn you more if you wish. Any data you wish to share with Mee will be securely stored and never shared with anyone unless you tell me to. Let’s start a conversation that will lead to Mee becoming your digital alter ego.", color: Colors.meeBrand, size: sizeClass == .compact ? 14 : 25)
//                                .frame(maxWidth: 500)
//                                .lineSpacing(5)
//                                .padding(.top, 5)
//                                .padding(.horizontal, 30)
//                        } else {
//                            BasicText(text:" I’m your privacy agent. \nI’m here to increase your privacy online. \nWhen apps or websites want to know something about you, \nI share as much or as little as you tell me to.", color: Colors.meeBrand, size: 40)
//                                .minimumScaleFactor(0.01)
//                                .lineSpacing(5)
//
//
//                        }
                    }.padding(.top, sizeClass == .compact ? 50 :  100)
                             , alignment: .top)
                RejectButton("Continue", action: onNext, fullWidth: true, withBorder: true)
                    .padding(.horizontal, 16)
                    .padding(.bottom, sizeClass == .compact ? 0 : 20)
                Spacer()
            }
            .padding(.top, 52)
            .padding(.horizontal, 8)
            
        }.ignoresSafeArea(.all)
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
    @State private var finalAnimation = false
    @State private var text: String = ""
    @State private var progress: CGFloat = 0
    @State private var animationMultiplier: CGFloat = 6
    
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                ZStack {
                    Image("mLogo").resizable()
                        .scaledToFit()
                        .frame(width: !self.finalAnimation ? 103.26 : 103.26 * animationMultiplier, height: !self.finalAnimation ? 71.61 : 71.61 * animationMultiplier, alignment: .center)
                        .transition(.scale)
                        .zIndex(10)
                        .padding(.vertical, 50)
                        .padding(.horizontal, 37)
                    
                    LoadingCircle(progress: progress, width: !self.finalAnimation ? 171 : 171 * animationMultiplier, height: !self.finalAnimation ? 171 : 171 * animationMultiplier)
                }
                .transition(.scale)
                .animation(Animation.linear(duration: 2), value: finalAnimation)
                .background(Colors.meeBrand)
                .cornerRadius(3)
                ZStack {
                    Text(text)
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
                if progress >= 1.5 {
                    timer.upstream.connect().cancel()
                    onNext()
                }
                if progress >= 1 {
                    withAnimation{
                        finalAnimation = true
                    }
                    //                             onNext()
                } else if progress < 0.1 {
                    text = "Generating unique device keys"
                } else if progress < 0.4 {
                    text = "Generating context data encryption key"
                } else if progress < 0.7 {
                    text = "Generating context-specific user indentifier"
                } else if progress < 0.9 {
                    text = "Creating Self in the Mee data storage"
                } else {
                    text = ""
                }
                
                progress += 0.02
            }
            .frame(maxWidth: .infinity)
            .opacity(finalAnimation ? 0 : 1)
            .animation(Animation.linear(duration: 2), value: finalAnimation)
            .background(finalAnimation ? Colors.meeBrand : nil)
        }
    }
}
