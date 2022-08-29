//
//  ConsentPage.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 16.02.2022.
//

import SwiftUI

struct ConsentPageNew: View {
    @StateObject var data = ConsentState()
    @Environment(\.openURL) var openURL
    @State private var showCertified = false
    var body: some View {
        ZStack {
            BackgroundWhite()

            if showCertified {
                VStack {
                    WebView(request: URLRequest(url: URL(string: "https://getmee.org/#/mee-certified")!))
                        .padding(.horizontal, 10)
                    SecondaryButton("Close", action: {
                        showCertified.toggle()
                    })
                }
            } else {
            VStack(spacing: 0) {
                ScrollView {
                VStack {
                    HStack {
                        Image("meeLogo").resizable().scaledToFit()
                            .frame(width: 48, alignment: .center)
                        Line()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                            .frame(height: 1)
                            .foregroundColor(Colors.meeBrand)
                        VStack {
                            Image("meeCertifiedLogo").resizable().scaledToFit()
                                .frame(width: 48, height: 48, alignment: .center)
                        }
                        Line()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                            .frame(height: 1)
                            .foregroundColor(Colors.meeBrand)
                        Image("nyTimesLogo").resizable().scaledToFit()
                            .frame(width: 48, height: 48, alignment: .center)
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            showCertified.toggle()
                        }) {
                            BasicText(text: "Mee-certified", color: Colors.meeBrand, size: 14, underline: true)
                        }
                        Spacer()
                    }
                    .offset(x: 0, y: -7)
                }
                .padding(.bottom, 24.0)
                .padding(.top, 30)
                Text(data.consent.name)
                    .foregroundColor(Colors.text)
                    .font(.custom(FontNameManager.PublicSans.bold, size: 30))
                HStack {
                    Image("lockIcon").resizable().scaledToFit()
                        .frame(height: 24)
                    Text(data.consent.url)
                        .foregroundColor(Colors.meeBrand)
                        .font(.custom(FontNameManager.PublicSans.bold, size: 30))
                }
                Text("would like access to some of your personal information")
                    .foregroundColor(Colors.textGrey)
                    .font(.custom(FontNameManager.PublicSans.medium, size: 18))
                    .padding(.bottom, 36.0)
                    .padding(.horizontal, 10)
                    .multilineTextAlignment(.center)
//                Button(action: buttonAction, label: {
//                    Text("Tap Here")
//                })
                
                    Expander(title: "See required info") {
                        ForEach($data.consent.entries.filter {$0.wrappedValue.isRequired}) { $entry in
                            ConsentEntry(entry: $entry)
                        }
                        .padding(.top, 16)
                    }
                    .padding(.bottom, 16)
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [1000]))
                        .frame(height: 1)
                        .foregroundColor(Colors.grey)
                        .padding(.bottom, 16)
                    Expander(title: "See optional info") {
                        ForEach($data.consent.entries.filter {!$0.wrappedValue.isRequired}) { $entry in
                            ConsentEntry(entry: $entry)
                        }
                        .padding(.top, 16)
                    }
                    
                    .padding(.bottom, 40)
                }


                Spacer()
                    VStack {
                        RejectButton("Decline", action: {
                            openURL(URL(string: "https://demo-dev.getmee.org/reject")!)
                        }, fullWidth: true)
                        SecondaryButton("Approve and Continue", action: {
                            openURL(URL(string: "https://demo-dev.getmee.org/?interest=world-news")!)
                        }, fullWidth: true)
                }
                .padding(.bottom, 30)
                .padding(.top, 0)
            }
            .padding(.horizontal, 16.0)
            
        }
        
    }
    }
    func buttonAction(){

    }
                                                     
    
}

struct ConsentPageAnimation: View {
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
                        
                    LoadingCircle(progress: 1, width: !self.finalAnimation ? 171 : 171 * animationMultiplier, height: !self.finalAnimation ? 171 : 171 * animationMultiplier)
                }
                .transition(.scale)
                .animation(Animation.linear(duration: 2), value: finalAnimation)
                .background(Colors.meeBrand)
                .cornerRadius(3)
                
                Spacer()
            }
            .onReceive(timer) { time in
                if progress >= 0.5 {
                    timer.upstream.connect().cancel()
                    onNext()
                }
                if progress >= 0.1 {
                    withAnimation{
                        finalAnimation = true
                    }
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

struct ConsentPageExisting: View {
    @StateObject var data = ConsentState()
    @Environment(\.openURL) var openURL
    @State private var showAnimation = true
    @State private var progress: CGFloat = 0

    var body: some View {
        ZStack {
            BackgroundWhite()

            if showAnimation {
                ConsentPageAnimation {
                    showAnimation = false
                }
            } else {
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        Image("meeLogo").resizable().scaledToFit()
                            .frame(width: 48, height: 48, alignment: .center)
                        Line()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                            .frame(height: 1)
                            .foregroundColor(Colors.meeBrand)
                        VStack {
                            Image("meeCertifiedLogo").resizable().scaledToFit()
                                .frame(width: 48, height: 48, alignment: .center)
                        }
                        Line()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                            .frame(height: 1)
                            .foregroundColor(Colors.meeBrand)
                        Image("nyTimesLogo").resizable().scaledToFit()
                            .frame(width: 48, height: 48, alignment: .center)
                    }
                }
                .padding(.bottom, 236.0)
                .padding(.top, 71.4)
                BasicText(text: "You are about to be logged in and redirected to", color: Colors.textGrey, size: 18)
                Text(data.consent.name)
                    .foregroundColor(Colors.text)
                    .font(.custom(FontNameManager.PublicSans.bold, size: 30))
                HStack {
                    Image("lockIcon").resizable().scaledToFit()
                        .frame(height: 24)
                    Text(data.consent.url)
                        .foregroundColor(Colors.meeBrand)
                        .font(.custom(FontNameManager.PublicSans.bold, size: 30))
                }
                Spacer()
                DelayedActionButton(title: "Don’t Make me Wait", action: {
                    openURL(URL(string: "https://demo-dev.getmee.org/?interest=world-news")!)
                }, delay: 5)
                .padding(.bottom, 57.5)

                

            }
            .ignoresSafeArea(.all)
            .padding(.horizontal, 16.0)
            
        }
        
        
        }
    }
                                                     
    
}


struct ConsentPage: View {
    private var isReturningUser = false
    private func onNext () {
        
    }
    var body: some View {
        if isReturningUser {
            ConsentPageExisting()
        }
        else {
            ConsentPageNew()
        }
    }
}
