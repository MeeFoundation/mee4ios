//
//  ConsentPageAnimation.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct ConsentPageAnimation: View {
    var onNext: () -> Void
    @State private var state = ConsentPageAnimationState()
    
    
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
                    
                    LoadingCircle(progress: 1, width: !state.finalAnimation ? 171 : 171 * state.animationMultiplier, height: !state.finalAnimation ? 171 : 171 * state.animationMultiplier)
                }
                .transition(.scale)
                .animation(Animation.linear(duration: 2), value: state.finalAnimation)
                .background(Colors.meeBrand)
                .cornerRadius(3)
                
                Spacer()
            }
            .onReceive(timer) { time in
                if state.progress >= 0.5 {
                    timer.upstream.connect().cancel()
                    onNext()
                }
                if state.progress >= 0.1 {
                    withAnimation{
                        state.finalAnimation = true
                    }
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

