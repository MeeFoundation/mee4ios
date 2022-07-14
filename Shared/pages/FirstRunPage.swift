//
//  FirstRun.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 08.07.2022.
//

import SwiftUI

enum FirstRunPages: Hashable {
  case prepare, faceId, faceIdSet, initializing
}


struct FirstRunPage: View {
    @AppStorage("launchedBefore") var launchedBefore: Bool = false
    @State private var currentPage = FirstRunPages.prepare
    
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

struct FirstRunPagePrepare: View {
    var onNext: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                Image("faceId").resizable()
                    .frame(width: 60.5, height: 60.5, alignment: .center)
                    .padding(.top, 14)
                    .zIndex(10)
                Text("Secure your Data!").font(Font.custom(FontNameManager.PublicSans.bold, size: 34))
                    .lineSpacing(41)
                    .padding(.bottom, 8)
                Text("Please set up \(biometricsTypeText), otherwise you can't use Mee")
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
