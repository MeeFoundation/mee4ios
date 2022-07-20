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
    }
    
    var body: some View {
        NavigationView {
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
                        Image("meeLogoInactive").resizable().scaledToFit()
                    }
                    .padding(.horizontal, 115.0).padding(.top, 35.0)
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
    var onNext: () -> Void
    var body: some View {
        ZStack {
            BackgroundYellow()
            VStack(spacing: 0) {
                Image("meeEntry").resizable().scaledToFit()
                    .overlay(VStack(spacing: 0) {
                        HStack {
                            BasicText(text:"Hello. ", color: Colors.textYellow, size: 30, fontName: FontNameManager.PublicSans.bold)
                            BasicText(text:"It’s Mee.", color: Colors.meeBrand, size: 30, fontName: FontNameManager.PublicSans.regularItalic)
                        }
                        BasicText(text:"I’m your digital twin - a digital representation of you. My job is to increase your privacy online. I do this by storing information about you in a secret database on this phone. When apps or websites want to know something about you, they ask me first. Under your direction, I share as much or as little as you tell me to.", color: Colors.meeBrand, size: 14).frame(width: 290)
                            .lineSpacing(5)
                            .padding(.top, 10)
                    }.padding(.top, 50)
                             , alignment: .top)
                RejectButton("Continue", action: onNext, fullWidth: true)
                .padding(.horizontal, 16)
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
                Text("Set up your Digital \n Twin").font(Font.custom(FontNameManager.PublicSans.bold, size: 34))
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    
                Text("To store your data, Mee contains a secure vault, which is safely encrypted by \(biometricsTypeText). \nPlease set up \(biometricsTypeText).")
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
                    .lineSpacing(41)
                    .padding(.bottom, 8)
                Text("Use \(biometricsTypeText) next time you sign-in")
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
                    text = "Creating a context in the Mee Data Storage"
                } else if progress < 0.4 {
                    text = "Generating the context data encryption key"
                } else if progress < 0.7 {
                    text = "Generating unique device keys"
                } else if progress < 0.9 {
                    text = "Generating the context-specific user indentifier"
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
