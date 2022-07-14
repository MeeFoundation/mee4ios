//
//  ConsentPage.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 16.02.2022.
//

import SwiftUI

struct ConsentPage: View {
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
                Text("Needs access to the following data:")
                    .foregroundColor(Colors.textGrey)
                    .font(.custom(FontNameManager.PublicSans.medium, size: 18))
                    .padding(.bottom, 24.0)
//                Button(action: buttonAction, label: {
//                    Text("Tap Here")
//                })
                Spacer()
                ScrollView {
                    ForEach(data.consent.entries) { entry in
                        ConsentEntry(consentEntry: entry)
                    }
                    .padding(.bottom, 20.0)
                    .padding(.trailing, 10.0)
                }
 
                .padding(.bottom, 10.0)


                Spacer()
                    VStack {
                        RejectButton("Decline", action: {
                            openURL(URL(string: "http://localhost:3001/#/reject")!)
                        }, fullWidth: true)
                        SecondaryButton("Approve", action: {
                            openURL(URL(string: "http://localhost:3001/?interest=world-news")!)
                        }, fullWidth: true)
                }
                .padding(.top, 10.0)
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 16.0)
            
        }
        
    }
    }
    func buttonAction(){

    }
                                                     
    
}
