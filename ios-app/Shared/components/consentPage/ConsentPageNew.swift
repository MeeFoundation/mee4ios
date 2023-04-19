//
//  ConsentPageNew.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct ConsentPageNew: View {
    
    @State private var state = ConsentPageNewState()
    @EnvironmentObject var data: ConsentState
    @AppStorage("isCompatibleWarningShown") var isCompatibleWarningShown: Bool = false
    @EnvironmentObject var toastState: ToastState
    @Environment(\.openURL) var openURL
    
    
    var onAccept: (ConsentRequest) -> Void
    init(onAccept: @escaping (ConsentRequest) -> Void) {
        self.onAccept = onAccept
    }
    
    var hasOptionalFields: Bool {
        get {
            return data.consent.claims.firstIndex(where: {!$0.isRequired}) != nil;
        }
    }
    
    var body: some View {
        GeometryReader { gr in
            BackgroundWhite()
            
            if state.showCertified {
                VStack {
                    if let certifiedUrl,
                       let compatibleUrl {
                        WebView(url: state.isCertified ? certifiedUrl : compatibleUrl)
                            .padding(.horizontal, 10)
                    }
                    
                    SecondaryButton("Close", action: {
                        state.showCertified.toggle()
                    })
                }
            } else {
                VStack(spacing: 0) {
                    ScrollViewReader {proxy in
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
                                        Button(action: {
                                            state.showCertified.toggle()
                                        }) {
                                            Image(state.isCertified ? "meeCertifiedLogo" : "meeCompatibleLogo").resizable().scaledToFit()
                                                .frame(width: 48, height: 48, alignment: .center)
                                        }
                                        .frame(width: 48, height: 48)
                                    }
                                    .overlay {
                                        Hint(show: $isCompatibleWarningShown, text: "This site is not Mee-certified. Your data does not have the extra protections provided by the Mee Human Information License.")
                                            .opacity(!state.isCertified && !isCompatibleWarningShown ? 1 : 0)
                                            .position(x: 35,y: 122)
                                    }
                                    Line()
                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                                        .frame(height: 1)
                                        .foregroundColor(Colors.meeBrand)
                                    AsyncImage(url: URL(string: data.consent.clientMetadata.logoUrl), content: { phase in
                                        if let image = phase.image {
                                            image.resizable().scaledToFit()
                                                .frame(width: 48, height: 48, alignment: .center)
                                        } else if phase.error != nil {
                                            ZStack{
                                                
                                            }.frame(width: 48, height: 48)
                                        } else {
                                            ProgressView()
                                        }
                                        
                                    })
                                    .frame(width: 48, height: 48, alignment: .center)
                                }
                                .padding(.bottom, 24.0)
                                .padding(.top, 30)
                                
                                Text(data.consent.clientMetadata.name)
                                    .foregroundColor(Colors.text)
                                    .font(.custom(FontNameManager.PublicSans.bold, size: 30))
                                
                                Text(URL(string: data.consent.id)?.host ?? data.consent.id)
                                    .foregroundColor(Colors.meeBrand)
                                    .font(.custom(FontNameManager.PublicSans.bold, size: 18))
                                
                                Text("would like access to your information")
                                    .foregroundColor(Colors.textGrey)
                                    .font(.custom(FontNameManager.PublicSans.medium, size: 18))
                                    .padding(.bottom, 36.0)
                                    .padding(.horizontal, 10)
                                    .multilineTextAlignment(.center)
                                    .zIndex(0)
                                
                                Expander(title: "Required", isOpen: $state.isRequiredSectionOpened) {
                                    
                                    ForEach($data.consent.claims.filter {$0.wrappedValue.isRequired}) { $entry in
                                        ConsentEntry(entry: $entry, isReadOnly: false) {
                                            state.durationPopupId = entry.id
                                        }
                                        .id(entry.id)
                                    }
                                    .padding(.top, 16)
                                }
                                
                                .padding(.bottom, 16)
                                Line()
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [1000]))
                                    .frame(height: 1)
                                    .foregroundColor(Colors.gray)
                                    .padding(.bottom, 16)
                                if hasOptionalFields
                                {
                                    Expander(title: "Optional", isOpen: $state.isOptionalSectionOpened) {
                                        ForEach($data.consent.claims.filter {!$0.wrappedValue.isRequired}) { $entry in
                                            ConsentEntry(entry: $entry, isReadOnly: false) {
                                                state.durationPopupId = entry.id
                                            }
                                            .id(entry.id)
                                        }
                                        .padding(.top, 16)
                                        
                                    }
                                    .padding(.bottom, 40)
                                    
                                    
                                }
                                
                            }
                            .padding(.bottom, 180)
                            .onChange(of: state.scrollPosition, perform: {newValue in
                                if let newValue {
                                    withAnimation {
                                        proxy.scrollTo(newValue)
                                    }
                                }
                            })
                            
                        }
                        .keyboardAvoiding()
                    }
                    Spacer()
                    
                }
                .padding(.horizontal, 16.0)
                .overlay(alignment: .bottom) {
                    ZStack {
                        VStack {
                            RejectButton("Decline", action: {
                                if let url = state.onDecline(data.consent.redirectUri) {
                                    openURL(url)
                                } else {
                                    toastState.toast = ToastMessage(type: .error, title: "Error", message: "Unknown Error")
                                }
                            }, fullWidth: true, isTransparent: true)
                            SecondaryButton("Approve and Connect", action: {
                                if let incorrectIndex = state.incorrectClaimIndex(data.consent.claims) {
                                    data.consent.claims[incorrectIndex].isOpen = true
                                    return
                                }
                                onAccept(data.consent)
                            },
                                            fullWidth: true
                            )
                        }
                        .padding(.bottom, 30)
                        
                        .padding(.top, 0)
                        .padding(.horizontal, 16)
                    }
                    .ignoresSafeArea(.all)
                    .background {
                        VisualEffectView(effect: UIBlurEffect(style: .light)).opacity(0.99).ignoresSafeArea(.all)
                    }
                    .frame(maxHeight: 150)
                    .ignoresSafeArea(.all)
                }
                
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            keyboardEndEditing()
                        }
                    }
                }
                .overlay {
                    PopupWrapper(isVisible: state.durationPopupId != nil) {
                        if let durationPopupId = state.durationPopupId {
                            ConsentDuration(consentEntries: $data.consent.claims, id: durationPopupId) {
                                state.durationPopupId = nil
                            }
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(SafeAreaRegions.container, edges: [.bottom])
    }
}

