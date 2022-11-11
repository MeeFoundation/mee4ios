//
//  ConsentPage.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 16.02.2022.
//

import SwiftUI

struct ConsentPageNew: View {
    @EnvironmentObject var data: ConsentState
    @EnvironmentObject var partners: PartnersState
    @AppStorage("isCompatibleWarningShown") var isCompatibleWarningShown: Bool = false
    @Environment(\.openURL) var openURL
    @State private var showCertified = false
    @State private var partner: PartnersModel?
    @State var durationPopupId: UUID? = nil
    var onAccept: (String, String, String) -> Void
    init(onAccept: @escaping (String, String, String) -> Void) {
        self.onAccept = onAccept
    }
    private var hasIncorrectFields: Bool {
        get {
            data.consent.entries.firstIndex(where: {$0.isIncorrect == true}) != nil;
        }
    }
    
    @State var isRequiredSectionOpened: Bool = true
    @State var isOptionalSectionOpened: Bool = false
    @State var scrollPosition: UUID? = nil
    let rejectUrl = URL(string: "https://demo-dev.meeproject.org/reject")
    var body: some View {
        ZStack {
            BackgroundWhite()
            
            if showCertified {
                VStack {
                    if let certifiedUrl {
                        if let compatibleUrl {
                            WebView(request: URLRequest(url: (partner?.isMeeCertified ?? false) ? certifiedUrl : compatibleUrl))
                                .padding(.horizontal, 10)
                        }
                        
                    }
                    
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
                                    Button(action: {
                                        showCertified.toggle()
                                    }) {
                                        Image((partner?.isMeeCertified ?? false) ? "meeCertifiedLogo" : "meeCompatibleLogo").resizable().scaledToFit()
                                            .frame(width: 48, height: 48, alignment: .center)
                                    }
                                    .frame(width: 48, height: 48)
                                    .onAppear{
                                        partner = partners.partners.first(where: { partner in
                                            partner.id == data.consent.id
                                        })
                                    }
                                    
                                }
                                .overlay {
                                    VStack(spacing: 0) {
                                        Triangle()
                                            .fill(Colors.meeBrand)
                                            .frame(width: 12, height: 6)
                                        VStack(spacing: 0) {
                                            
                                            BasicText(
                                                text: "This site is not Mee-certified. Your data does not have the extra protections provided by the Mee Human Information License.",
                                                color: .white,
                                                size: 14, textAlignment: .leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .fixedSize(horizontal: false, vertical: true)
                                            Button(action: {
                                                isCompatibleWarningShown = true
                                            }) {
                                                BasicText(text: "Got it", color: .white, size:14).frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                            .padding(.top, 16)
                                        }
                                        
                                        .frame(width: 249)
                                        .padding(.horizontal, 16)
                                        .padding(.top, 28)
                                        .padding(.bottom, 16)
                                        .background(Colors.meeBrand)
                                        .cornerRadius(10)
                                        
                                        
                                    }
                                    .opacity(!(partner?.isMeeCertified ?? false) && !isCompatibleWarningShown ? 1 : 0)
                                    .position(x: 35,y: 122)
                                    
                                    
                                }
                                
                                Line()
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                                    .frame(height: 1)
                                    .foregroundColor(Colors.meeBrand)
                                AsyncImage(url: URL(string: data.consent.imageUrl), content: { phase in
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
                        //                Button(action: buttonAction, label: {
                        //                    Text("Tap Here")
                        //                })
                        ScrollViewReader {value in
                            Expander(title: "Required", isOpen: $isRequiredSectionOpened) {
                                ForEach($data.consent.entries.filter {$0.wrappedValue.isRequired}) { $entry in
                                    ConsentEntry(entry: $entry) {
                                        durationPopupId = entry.id
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
                            Expander(title: "Optional", isOpen: $isOptionalSectionOpened) {
                                ForEach($data.consent.entries.filter {!$0.wrappedValue.isRequired}) { $entry in
                                    ConsentEntry(entry: $entry) {
                                        durationPopupId = entry.id
                                    }
                                    .id(entry.id)
                                }
                                .padding(.top, 16)
                            }.onChange(of: scrollPosition, perform: {newValue in
                                withAnimation {
                                    value.scrollTo(newValue)
                                }
                            })
                            
                            .padding(.bottom, 40)
                        }
                    }
                    
                    
                    
                    Spacer()
                    VStack {
                        RejectButton("Decline", action: {
                            keyboardEndEditing()
                            if let rejectUrl {
                                openURL(rejectUrl)
                            }
                        }, fullWidth: true)
                        SecondaryButton("Approve and Continue", action: {
                            keyboardEndEditing()
                            if (!hasIncorrectFields) {
                                onAccept(encodeJson(data.consent.entries.filter{ entry in entry.value != nil }), data.consent.id, data.consent.url)
                            } else {
                                if let incorrectFieldIndex = data.consent.entries.firstIndex(where: {$0.isIncorrect == true}) {
                                    if (data.consent.entries[incorrectFieldIndex].isRequired) {
                                        isRequiredSectionOpened = true
                                    } else {
                                        isOptionalSectionOpened = true
                                    }
                                    data.consent.entries[incorrectFieldIndex].isOpen = true
                                    scrollPosition = data.consent.entries[incorrectFieldIndex].id
                                }
                            }
                        },
                                        fullWidth: true
                        )
                    }
                    .padding(.bottom, 30)
                    .padding(.top, 0)
                    .background(.white.opacity(50))
                    
                }
                .padding(.horizontal, 16.0)
                .overlay {
                    PopupWrapper(isVisible: durationPopupId != nil) {
                        if let durationPopupId {
                            ConsentDuration(consentEntries: $data.consent.entries, id: durationPopupId) {
                                self.durationPopupId = nil
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
                    onAccept(data.consent.id, data.consent.url)
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
                    //                    DelayedActionButton(title: "Don’t Make me Wait", action: {
                    //                        openURL(URL(string: "https://demo-dev.meeproject.org/?interest=world-news")!)
                    //                    }, delay: 5)
                        .padding(.bottom, 57.5)
                    
                    
                    
                }
                .ignoresSafeArea(.all)
                .padding(.horizontal, 16.0)
                
            }
            
            
        }
    }
    
    
}


struct ConsentPage: View {
    var isLocked: Bool
    @AppStorage("recoveryPassphrase") var recoveryPassphrase: String?
    @EnvironmentObject var data: ConsentState
    @State private var isPresentingAlert: Bool = false
    let keyChainConsents = KeyChainConsents()
    @State var isReturningUser: Bool?
    @Environment(\.openURL) var openURL
    
    private func onNext (_ jwtToken: String,_ url: String) {
        //        if recoveryPassphrase == nil {
        //            isPresentingAlert = true
        //        } else {
        if let url = URL(string: "\(url)/?token=\(jwtToken)") {
            openURL(url)
            isReturningUser = true
        }
        
        //        }
    }
    var body: some View {
        ZStack {
            if !isLocked {
                if let isReturningUser {
                    if isReturningUser {
                        ConsentPageExisting() {id, url in
                            print(id)
                            guard let data = keyChainConsents.getItemByName(name: id) else {
                                return
                            }
                            print(data)
                            onNext(data, url)
                            
                        }
                    }
                    else {
                        ConsentPageNew(){data, id, url in
                            print(data)
                            keyChainConsents.editItem(name: id, item: data.toBase64())
                            onNext(data.toBase64(), url)
                        }
                    }
                }
            }
            
        }
        .onAppear{
            isReturningUser = keyChainConsents.getItemByName(name: data.consent.id) != nil
        }
        .alert(isPresented: $isPresentingAlert) {
            Alert(title: Text("Set Up Secret Recovery Phrase"), message: Text("Before you will be logged in, let’s set up your secret recovery phrase"), dismissButton: .default(Text("Set Up Secret Recovery Phrase"), action: {
                // TODO: need to redirect to recovery phrase generator ans pass action url to it, so it can redirect us there after passphrase generation
                recoveryPassphrase = "some recovery passphrase"
            }))
        }
    }
}

