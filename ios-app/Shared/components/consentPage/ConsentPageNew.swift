//
//  ConsentPageNew.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct ConsentPageNew: View {
    @EnvironmentObject var data: ConsentState
    @EnvironmentObject var partners: CertifiedPartnersState
    @AppStorage("isCompatibleWarningShown") var isCompatibleWarningShown: Bool = false
    @Environment(\.openURL) var openURL
    @State private var state = ConsentPageNewState()
    var isCertified: Bool {
        partners.partners.firstIndex(where: { partner in
            partner.client_id == data.consent.id
        }) != nil
    }
    var onAccept: ([ConsentEntryModel], String, String) -> Void
    init(onAccept: @escaping ([ConsentEntryModel], String, String) -> Void) {
        self.onAccept = onAccept
    }
    private var hasIncorrectFields: Bool {
        get {
            data.consent.entries.firstIndex(where: {$0.isIncorrect == true}) != nil;
        }
    }
    let rejectUrl = URL(string: "https://demo-dev.mee.foundation/#/reject")
    var body: some View {
        ZStack {
            BackgroundWhite()
            
            if state.showCertified {
                VStack {
                    if let certifiedUrl {
                        if let compatibleUrl {
                            WebView(request: URLRequest(url: isCertified ? certifiedUrl : compatibleUrl))
                                .padding(.horizontal, 10)
                        }
                        
                    }
                    
                    SecondaryButton("Close", action: {
                        state.showCertified.toggle()
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
                                    Button(action: {
                                        state.showCertified.toggle()
                                    }) {
                                        Image(isCertified ? "meeCertifiedLogo" : "meeCompatibleLogo").resizable().scaledToFit()
                                            .frame(width: 48, height: 48, alignment: .center)
                                    }
                                    .frame(width: 48, height: 48)
                                    .onAppear{
                                        state.partner = partners.partners.first(where: { partner in
                                            partner.client_id == data.consent.id
                                        })
                                    }
                                    
                                }
                                .overlay {
                                    Hint(show: $isCompatibleWarningShown, text: "This site is not Mee-certified. Your data does not have the extra protections provided by the Mee Human Information License.")
                                        .opacity(!isCertified && !isCompatibleWarningShown ? 1 : 0)
                                    .position(x: 35,y: 122)
                                    
                                    
                                }
                                
                                Line()
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                                    .frame(height: 1)
                                    .foregroundColor(Colors.meeBrand)
                                AsyncImage(url: URL(string: data.consent.logoUrl), content: { phase in
                                    if let image = phase.image {
                                        image.resizable().scaledToFit()
                                            .frame(width: 48, height: 48, alignment: .center)
                                    } else {
                                        ProgressView()
                                    }
                                    
                                })
                                .frame(width: 48, height: 48, alignment: .center)
                            }
                        }
                        .zIndex(1)
                        .padding(.bottom, 24.0)
                        .padding(.top, 30)
                        Text(data.consent.name)
                            .foregroundColor(Colors.text)
                            .font(.custom(FontNameManager.PublicSans.bold, size: 30))
                        
                        Text(data.consent.displayUrl)
                            .foregroundColor(Colors.meeBrand)
                            .font(.custom(FontNameManager.PublicSans.bold, size: 18))
                        
                        Text("would like access to your information")
                            .foregroundColor(Colors.textGrey)
                            .font(.custom(FontNameManager.PublicSans.medium, size: 18))
                            .padding(.bottom, 36.0)
                            .padding(.horizontal, 10)
                            .multilineTextAlignment(.center)
                            .zIndex(0)

                        ScrollViewReader {value in
                            Expander(title: "Required", isOpen: $state.isRequiredSectionOpened) {
                                ForEach($data.consent.entries.filter {$0.wrappedValue.isRequired}) { $entry in
                                    ConsentEntry(entry: $entry) {
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
                            Expander(title: "Optional", isOpen: $state.isOptionalSectionOpened) {
                                ForEach($data.consent.entries.filter {!$0.wrappedValue.isRequired}) { $entry in
                                    ConsentEntry(entry: $entry) {
                                        state.durationPopupId = entry.id
                                    }
                                    .id(entry.id)
                                }
                                .padding(.top, 16)
                            }.onChange(of: state.scrollPosition, perform: {newValue in
                                withAnimation {
                                    value.scrollTo(newValue)
                                }
                            })
                            
                            .padding(.bottom, 40)
                        }
                        .padding(.bottom, 180)
                    }
                    
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 16.0)
                .overlay(alignment: .bottom) {
                    ZStack {
                        
                        VStack {
                            RejectButton("Decline", action: {
                                keyboardEndEditing()
                                if let rejectUrl {
                                    openURL(rejectUrl)
                                }
                            }, fullWidth: true, isTransparent: true)
                            SecondaryButton("Approve and Connect", action: {
                                keyboardEndEditing()
                                if (!hasIncorrectFields) {
                                    onAccept(data.consent.entries.filter{ entry in entry.value != nil && (entry.isRequired || entry.isOn) }, data.consent.id, data.consent.acceptUrl)
                                } else {
                                    if let incorrectFieldIndex = data.consent.entries.firstIndex(where: {$0.isIncorrect == true}) {
                                        if (data.consent.entries[incorrectFieldIndex].isRequired) {
                                            state.isRequiredSectionOpened = true
                                        } else {
                                            state.isOptionalSectionOpened = true
                                        }
                                        data.consent.entries[incorrectFieldIndex].isOpen = true
                                        state.scrollPosition = data.consent.entries[incorrectFieldIndex].id
                                    }
                                }
                            },
                                            fullWidth: true
                            )
                        }
                        .padding(.bottom, 30)
                        
                        .padding(.top, 0)
                        .padding(.horizontal, 16)
                    }
                    .background {
                        VisualEffectView(effect: UIBlurEffect(style: .light)).opacity(0.99).ignoresSafeArea(.all)
                    }
                    .frame(maxHeight: 159)
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
                            ConsentDuration(consentEntries: $data.consent.entries, id: durationPopupId) {
                                state.durationPopupId = nil
                            }
                        }
                    }
                }
            }
            
            
        }
    }
    func buttonAction(){
        
    }
    
    
}

