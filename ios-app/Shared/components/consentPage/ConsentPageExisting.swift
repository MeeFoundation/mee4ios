//
//  ConsentPageExisting.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct ConsentPageExisting: View {
    @EnvironmentObject var data: ConsentState
    @Environment(\.openURL) var openURL
    @State private var showAnimation = true
    @State private var progress: CGFloat = 0
    var onAccept: (String, String) -> Void
    init(onAccept: @escaping (String, String) -> Void) {
        self.onAccept = onAccept
    }
    
    var body: some View {
        ZStack {
            BackgroundWhite()
            
            if showAnimation {
                ConsentPageAnimation {
                    onAccept(data.consent.id, data.consent.id)
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
                    Text(data.consent.clientMetadata.name)
                        .foregroundColor(Colors.text)
                        .font(.custom(FontNameManager.PublicSans.bold, size: 30))
                    HStack {
                        Image("lockIcon").resizable().scaledToFit()
                            .frame(height: 24)
                        Text(data.consent.redirectUri)
                            .foregroundColor(Colors.meeBrand)
                            .font(.custom(FontNameManager.PublicSans.bold, size: 30))
                    }
                    Spacer()
                        .padding(.bottom, 57.5)
                    
                    
                    
                }
                .ignoresSafeArea(.all)
                .padding(.horizontal, 16.0)
                
            }
            
            
        }
    }
    
    
}
