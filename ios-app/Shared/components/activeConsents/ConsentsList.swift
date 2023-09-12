//
//  ConsentsList.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct ConsentsList: View, MeeAgentStoreListener {
    var core = MeeAgentStore.shared
    var registry = PartnersRegistry.shared
    @EnvironmentObject var navigationState: NavigationState
    @EnvironmentObject private var toastState: ToastState
    @EnvironmentObject var data: ConsentState
    
    @State private var state = ConsentsListState()
    @Environment(\.openURL) var openURL
    
    var id = UUID()
    func onUpdate() {
        onUpdate(isFirstRender: false)
    }
    @State var text = "Hello World"
    
    func processUrl(url: String) {
        if let url = URL(string: url) {
            if (url.scheme == "meeappdemo") {
                guard let host = url.host else {
                    return
                }
                if (host == "create") {
                    
                    Task {
                        let result = await core.authAuthRequestFromUrl(url: privoMockUrl, isCrossDevice: false ,sdkVersion: defaultSdkVersion)
                        guard let result else {
                            return
                        }
                        await core.authorize(id: result.id, item: ConsentRequest(from: Context(from: SiopConsentUniffi(id: result.id, otherPartyConnectionId: result.id, createdAt: String(Date().currentTimeMillis()), attributes: ["age_protect" : OidcClaimParams(essential: true, attributeType: "https://schema.org/name", name: "Age Protect", typ: "ageProtect", retentionDuration: .whileUsingApp, businessPurpose: "", isSensitive: true, value: #"{"jurisdiction":"Jurisdiction: MA, US","age":"Age: 15","dateOfBirth":"Birthdate: 30.03.2008"}"#)])), consentRequest: result))
                        await MainActor.run {
                            toastState.toast = ToastMessage(type: .success, title: "Privo Age Protect", message: "Connection created")
                        }
                        
                    }
                } else if (host == "confirm") {
                    let isCrossDevice = url.path.count > 0
                    Task {
                        let allConnections = await core.getAllItems()
                        
                        if (allConnections.contains(where: { connection in
                            print("connection.name: ", connection.name)
                            return connection.name == "Privo"
                        })) == false {
                            return
                        }
                        
                        let consent = await core.authAuthRequestFromUrl(url: privoMockUrl, isCrossDevice: isCrossDevice ,sdkVersion: defaultSdkVersion)
                        guard let consent else {
                            return
                        }
                        
                        await MainActor.run {
                            data.consent = ConsentRequest(claims: consent.claims, clientMetadata: consent.clientMetadata, nonce: String(url.path.dropFirst()), clientId: consent.clientId, redirectUri: consent.redirectUri, presentationDefinition: consent.presentationDefinition, isCrossDevice: consent.isCrossDeviceFlow, sdkVersion: consent.sdkVersion)
                            navigationState.currentPage = .consent
                        }
                        
                    }
                    
                    
                }
                
            }
        }
    }
    
    func onUpdate(isFirstRender: Bool) {
        
        Task.init {
            let currentConnections = await core.getAllItems()
            print("currentConnections: ", currentConnections)
            await MainActor.run {
                refreshPartnersList(data: currentConnections)
            }
        }
    }
    
    init() {
        
    }
    
    
    func refreshPartnersList(data: [Connection]) {
        state.existingPartnersWebApp = data.filter{ context in
            switch (context.value) {
            case .Siop(let value):
                return value.clientMetadata.type == .web
            case .Gapi(_):
                return true
            default: return false
            }
        }
        state.existingPartnersMobileApp = data.filter{ context in
            if case let .Siop(value) = context.value {
                return value.clientMetadata.type == .mobile
            }
            return false
        }
        state.otherPartnersWebApp = registry.partners.filter { context in
            let isNotPresentedInExistingList = state.existingPartnersWebApp?.firstIndex{$0.id.getHostname() == context.id.getHostname()} == nil
            let isGapiInList = state.existingPartnersWebApp?.firstIndex{$0.isGapi} != nil
            let isGapiInListAndEntryIsGapi = isGapiInList && context.isGapi
            return isNotPresentedInExistingList && !isGapiInListAndEntryIsGapi
            
        }

    }
    
    var body: some View {
        if (state.showQrCodeScanner) {
            VStack {
                BasicText(text: "Please scan any Mee-compatible QR code", color: .black)
                Spacer()
                QrCodeScannerView()
                    .found(r: {newValue in
                        print(newValue)
                        if (newValue.starts(with: "meeappdemo")) {
                            processUrl(url: newValue)
                            state.showQrCodeScanner = false
                        }
                        
                    })
                    .torchLight(isOn: state.cameraLightOn)
                    .border(Colors.meeBrand, width: 1)
                    .padding(.bottom, 20)
                    .frame(width: 300, height: 300)
                Spacer()
                HStack {
                    Button(action: {
                        state.cameraLightOn.toggle()
                    }) {
                        SecondaryButton("Close", action: {
                            state.showQrCodeScanner.toggle()
                        })
                            
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                
                
            }
            .padding(.top, 50)
            .padding(.bottom, 20)
            .padding(.horizontal, 50)
            .zIndex(1000)
            
            
        } else {
            ZStack {
                
                if state.showCertifiedOrCompatible != nil {
                    VStack {
                        if let certifiedUrl {
                            if let compatibleUrl {
                                WebView(url: state.showCertifiedOrCompatible == .certified ? certifiedUrl : compatibleUrl)
                                    .padding(.horizontal, 10)
                            }
                            
                        }
                        
                        SecondaryButton("Close", action: {
                            state.showCertifiedOrCompatible = nil
                        })
                        .padding(.bottom, 10)
                    }
                } else {
                    ZStack {
                        VStack {
                            HStack {
                                Spacer()
                                BasicText(
                                    text: "Connections",
                                    color: .white ,
                                    size: 17,
                                    fontName: FontNameManager.PublicSans.semibold,
                                    weight: .semibold
                                )
                                .padding(.leading, 16)
                                Spacer()
                                Button(action: {
                                    state.showQrCodeScanner =  true
                                }) {
                                    Image(systemName: "qrcode")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                        .foregroundColor(.white)
                                }
                                
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 59)
                            .padding(.bottom, 10)
                            .padding(.horizontal, 16)
                            .background(Colors.meeBrand)
                            .shadow(color: Color.black.opacity(0.3), radius: 0, x: 0, y: 0.5)
                            ScrollView {
                                VStack {
                                    ForEach([PartnerArray(data: state.existingPartnersWebApp, name: "Sites", editable: true),
                                             PartnerArray(data: state.existingPartnersMobileApp, name: "Mobile Apps", editable: true),
                                             PartnerArray(data: state.otherPartnersWebApp, name: "Sites to connect to", editable: false)
                                            ]) { partnersArray in
                                        if !(partnersArray.data ?? []).isEmpty {HStack {
                                            BasicText(text: partnersArray.name, color: Colors.text, size: 16, fontName: FontNameManager.PublicSans.medium)
                                            Spacer()
                                        }
                                        .padding(.leading, 4)
                                        .padding(.top, 24)
                                        .padding(.bottom, 4)
                                        }
                                        ForEach(partnersArray.data ?? []) { partnerData in
                                            NavigationLink(
                                                destination: PartnerDetails(connection: partnerData),
                                                tag: partnerData.id,
                                                selection: $state.selection
                                            ){}
                                            PartnerEntry(connection: partnerData, hasEntry: partnersArray.editable)
                                                .onTapGesture(perform: {
                                                    if partnersArray.editable {
                                                        state.selection = partnerData.id
                                                        
                                                    }
                                                    else {
                                                        switch (partnerData.value) {
                                                        case .Gapi(_):
                                                            state.showCompatibleWarning = true
                                                        default:
                                                            if let url = URL(string: partnerData.id) {
                                                                openURL(url)
                                                            }
                                                        }
                                                        
                                                    }
                                                })
                                                .padding(.top, 8)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                
                            }
//                            VStack {
//                                Button(action: {
//                                    state.showCertifiedOrCompatible = .certified
//                                }) {
//                                    HStack {
//                                        Image("meeCertifiedLogo").resizable().scaledToFit().frame(width: 20)
//                                        BasicText(text:"Mee-certified?", color: Colors.meeBrand, size: 14, underline: true)
//                                    }
//                                }
//                                
//                            }
//                            .padding(.bottom, 20)
//                            .padding(.top, 10)
//                            .frame(maxWidth: .infinity)
//                            .background(Color.white)
                            
                        }
                        .background(Color.white)
                        
                    }
                    .ignoresSafeArea(.all)
                    .background(Color.white)
                    .frame(maxWidth: .infinity)
                    .overlay {
                        WarningPopup(text: "You will be redirected to your default browser to login to your Google Account and retrieve your data from it to the Mee Smartwallet local storage", iconName: "google") {
                            state.showCompatibleWarning = false
                            Task.init {
                                if let url = await core.getGoogleIntegrationUrl() {
                                    await MainActor.run {
                                        openURL(url)
                                    }
                                    
                                }
                            }
                            
                        }
                        .ignoresSafeArea(.all)
                        .opacity(state.showCompatibleWarning ? 1 : 0)
                    }
                    
                    
                }
                
            }
            .onAppear {
                core.addListener(self)
                onUpdate(isFirstRender: true)
            }
            .onDisappear {
                core.removeListener(self)
            }
            .ignoresSafeArea(.all)
        }
            
            
        
    }
}

