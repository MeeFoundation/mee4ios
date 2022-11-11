//
//  PasswordManager.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 15.03.2022.
//

import SwiftUI

struct DashboardView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Image("userAvatarFrameImage").resizable().frame(width: 48, height: 48)
                        .overlay {
                            Image(systemName: "person.crop.circle.fill").resizable().frame(width: 32, height: 32).foregroundColor(.white)
                        }
                        .padding(.leading, 16)
                    Image("addNewUserImage").resizable().frame(width: 32, height: 32).padding(.leading, 16)
                    Spacer()
                    Image("notificationImage").resizable().frame(width: 24, height: 24).padding(.trailing, 24)
                }
                .padding(.bottom, 16)
                .padding(.top, 53)
                .frame(height: 117)
                .frame(maxWidth: .infinity)
                .background(.white.opacity(0.5))
                Spacer()
                Image("meeDashboardImage").resizable().frame(alignment: Alignment.center).scaledToFit()
                    .padding(.top, 72)
                    .padding(.bottom, sizeClass == .compact ? 130 : 200)
                    .frame(maxWidth: 500)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        .background(Colors.meeBrandYellow)
    }
}

struct PartnerEntry: View  {
    let partner: PartnersModel
    let canClick: Bool
    let isDetailedView: Bool
    @Binding var selection: String?
    var onRemove: () -> Void
    init(partner: PartnersModel, canClick: Bool = false, isDetailedView: Bool = false, selection: Binding<String?>, onRemove: @escaping () -> Void) {
        self.partner = partner
        self.canClick = canClick
        self._selection = selection
        self.onRemove = onRemove
        self.isDetailedView = isDetailedView
    }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        
        return Button(action: {
            if canClick {
                selection = partner.id
            }
        }){
            
            HStack {
                AsyncImage(url: URL(string: partner.imageUrl), content: { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFit().aspectRatio(contentMode: ContentMode.fill)
                            .frame(width: 48, height: 48, alignment: .center)
                            .clipShape(Circle())
                    } else {
                        ProgressView()
                    }
                    
                })
                .frame(width: 48, height: 48)
                
                VStack {
                    HStack {
                        Text(partner.name)
                            .foregroundColor(Colors.text)
                            .font(.custom(FontNameManager.PublicSans.medium , size: 16))
                        Image(partner.isMeeCertified ? "meeCertifiedLogo" : "meeCompatibleLogo").resizable().scaledToFit().frame(width: 20)
                        Spacer()
                    }
                    
                    BasicText(text: partner.displayUrl, color: Colors.text, size: 12, align: .left, fontName: FontNameManager.PublicSans.regular)
                }
                .padding(.leading, 8)
                Spacer()
                if canClick {
                    HStack {
                        Spacer()
                        Image("arrowRight").resizable().scaledToFit()
                            .frame(width: 7)
                    }
                    .frame(width: 48, height: 48)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
            .padding(.bottom, 8)
            .padding(.leading, 8)
            .padding(.trailing, 9)
            .background(Colors.gray100)
        }
        
    }
    
}

struct PartnerDetails: View {
    let partner: PartnersModel
    var onRemove: () -> Void
    @State var durationPopupId: UUID? = nil
    init(partner: PartnersModel, onRemove: @escaping () -> Void) {
        self.partner = partner
        self.onRemove = onRemove
    }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let keychain = KeyChainConsents()
    @State var consentEntries: [ConsentEntryModel] = []
    @State var isRequiredOpen: Bool = true
    @State var isOptionalOpen: Bool = false
    @State var selection: String? = nil
    
    var body: some View {
        return (
            
            VStack {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        
                    }) {
                        HStack {
                            Image(systemName: "chevron.backward")
                            
                            Text("Back")
                                .foregroundColor(Colors.text)
                                .font(.custom(FontNameManager.PublicSans.regular , size: 18))
                        }
                        .padding(.leading, 9)
                    }
                    Spacer()
                    BasicText(text: "Manage Connection", color: .black ,size: 17, fontName: FontNameManager.PublicSans.semibold)
                        .padding(.trailing, 69)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 59)
                .padding(.bottom, 10)
                .background(Colors.backgroundAlt1)
                .shadow(color: Color.black.opacity(0.3), radius: 0, x: 0, y: 0.5)
                ScrollView {
                    PartnerEntry(partner: partner, canClick: false, isDetailedView: true, selection: $selection) {
                        onRemove()
                    }
                    .border(Colors.meeBrand, width: 2)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 48)
                    .padding(.top, 16)
                    Expander(title: "Required info shared", isOpen: $isRequiredOpen) {
                        ForEach($consentEntries.filter {$0.wrappedValue.isRequired}) { $entry in
                            VStack {
                                ConsentEntry(entry: $entry) {
                                    durationPopupId = entry.id
                                }
                                .id(entry.id)
                                Divider()
                                    .frame(height: 1)
                                    .background(Colors.gray)
                            }
                            
                            
                        }
                        .padding(.top, 19)
                        .padding(.leading, 3)
                        
                    }
                    .padding(.horizontal, 16)
                    if $consentEntries.firstIndex {!$0.wrappedValue.isRequired} != nil {
                        Expander(title: "Optional info shared", isOpen: $isOptionalOpen) {
                            ForEach($consentEntries.filter {!$0.wrappedValue.isRequired}) { $entry in
                                VStack {
                                    ConsentEntry(entry: $entry) {
                                        durationPopupId = entry.id
                                    }
                                    .id(entry.id)
                                    Divider()
                                        .frame(height: 1)
                                        .background(Colors.gray)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                    Spacer()
             
                        Button(action: {
                            
                        }){
                            HStack(spacing: 0) {
                                BasicText(text: "Block Connection", color: Color.black, size: 17)
                                Spacer()
                                Image("blockIcon").resizable().scaledToFit().frame(height: 17)
                            }
                            .padding(.vertical, 12)
                            .padding(.leading, 16)
                            .padding(.trailing, 19)
                            .background(.white)
                        }
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 64, x: 0, y: 8)
                        .padding(.bottom, 16)
                        .padding(.top, 80)
                        .padding(.horizontal, 16)
                        
                        
                    Button(action: onRemove){
                            HStack(spacing: 0) {
                                BasicText(text: "Delete Connection", color: Colors.error, size: 17)
                                Spacer()
                                Image("trashIcon").resizable().scaledToFit().frame(height: 17)
                            }
                            .padding(.vertical, 12)
                            .padding(.leading, 16)
                            .padding(.trailing, 19)
                            .background(.white)
                        }
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 64, x: 0, y: 8)
                        .padding(.bottom, 16)
                        .padding(.horizontal, 16)
                }
                
                
            }
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                .onAppear{
                    let consentDataString = keychain.getItemByName(name: partner.id)
                    if let consentDataString {
                        do {
                            if let consentDataDecodedString = consentDataString.fromBase64() {
                                if let consentData = consentDataDecodedString.data(using: .utf8) {
                                    consentEntries = try JSONDecoder().decode([ConsentEntryModel].self, from: consentData)
                                }
                                
                            }
                            
                        } catch {
                            
                        }
                        
                        
                    }
                    
                }
                .overlay {
                    PopupWrapper(isVisible: durationPopupId != nil) {
                        if let durationPopupId {
                            ConsentDuration(consentEntries: $consentEntries, id: durationPopupId){
                                self.durationPopupId = nil
                            }
                        }
                        
                    }
                }
        )
    }
}

enum CertifiedOrCompatible {
    case certified
    case compatible
}

struct PartnerArray: Identifiable {
    var id: String {
        return name
    }
    var data: [PartnersModel]?
    var name: String
    var editable: Bool
}

struct ConsentsList: View {
    let keychain = KeyChainConsents()
    @EnvironmentObject var data: PartnersState
    @State var selection: String? = nil
    @State var existingPartnersWebApp: [PartnersModel]?
    @State var otherPartnersWebApp: [PartnersModel]?
    @State var existingPartnersMobileApp: [PartnersModel]?
    @State var otherPartnersMobileApp: [PartnersModel]?
    @State var showWelcome: Bool?
    @State private var showCertifiedOrCompatible: CertifiedOrCompatible? = nil
    @State var showCompatibleWarning: Bool = false
    
    func removeConsent(_ id: String) {
        keychain.removeItembyName(name: id)
        if let partnerIndex = existingPartnersWebApp?.firstIndex(where: { p in
            p.id == id
        }) {
            existingPartnersWebApp?.remove(at: partnerIndex)
        }
        if let partnerIndex = existingPartnersMobileApp?.firstIndex(where: { p in
            p.id == id
        }) {
            existingPartnersMobileApp?.remove(at: partnerIndex)
        }
    }
    func refreshPartnersList(_ firstLaunch: Bool) {
        existingPartnersWebApp = data.partners.filter{ partner in
            !partner.isMobileApp && keychain.getItemByName(name: partner.id) != nil
        }
        existingPartnersMobileApp = data.partners.filter{ partner in
            partner.isMobileApp && keychain.getItemByName(name: partner.id) != nil
        }
        if firstLaunch {
            if let existingPartnersWebApp {
                if let existingPartnersMobileApp {
                    if existingPartnersWebApp.isEmpty && existingPartnersMobileApp.isEmpty {
                        showWelcome = true
                    } else {
                        showWelcome = false
                    }
                }
                
            }
        }
        
        otherPartnersWebApp = data.partners.filter{ partner in
            if partner.id == "nytcompatible" || (partner.id == "nyt" && !(existingPartnersWebApp ?? []).isEmpty) {return false}
            return !partner.isMobileApp && keychain.getItemByName(name: partner.id) == nil
        }
        otherPartnersMobileApp = data.partners.filter{ partner in
            return partner.isMobileApp && keychain.getItemByName(name: partner.id) == nil
        }
    }
    
    var body: some View {
        
        ZStack {
            if showCertifiedOrCompatible != nil {
                VStack {
                    if let certifiedUrl {
                        if let compatibleUrl {
                            WebView(request: URLRequest(url: (showCertifiedOrCompatible == .certified) ? certifiedUrl : compatibleUrl))
                                .padding(.horizontal, 10)
                        }
                        
                    }
                    
                    SecondaryButton("Close", action: {
                        showCertifiedOrCompatible = nil
                    })
                    .padding(.bottom, 10)
                }
            } else {
                
                if showWelcome != nil {
                    if showWelcome == false {
                        NavigationView {
                            ZStack {
                                VStack {
                                    ZStack {
                                        BasicText(text: "Connections", color: .black ,size: 17, fontName: FontNameManager.PublicSans.semibold)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 59)
                                    .padding(.bottom, 10)
                                    .background(Colors.backgroundAlt1)
                                    .shadow(color: Color.black.opacity(0.3), radius: 0, x: 0, y: 0.5)
                                    ScrollView {
                                        VStack {
                                            ForEach([PartnerArray(data: existingPartnersWebApp, name: "Sites", editable: true),
                                                     PartnerArray(data: existingPartnersMobileApp, name: "Mobile Apps", editable: true),
                                                     PartnerArray(data: otherPartnersWebApp, name: "Other Sites You Might Like", editable: false),
                                                     PartnerArray(data: otherPartnersMobileApp, name: "Other Mobile Apps You Might Like", editable: false)]) { partnersArray in
                                                if !(partnersArray.data ?? []).isEmpty {HStack {
                                                    BasicText(text: partnersArray.name, color: Colors.text, size: 16, fontName: FontNameManager.PublicSans.medium)
                                                    Spacer()
                                                }
                                                .padding(.leading, 4)
                                                .padding(.top, 24)
                                                .padding(.bottom, 4)
                                                }
                                                ForEach(partnersArray.data ?? []) { partner in
                                                    NavigationLink(destination: PartnerDetails(partner: partner, onRemove: {
                                                        removeConsent(partner.id)
                                                    }), tag: partner.id, selection: $selection){}
                                                    PartnerEntry(partner: partner, canClick: partnersArray.editable, selection: $selection) {
                                                        removeConsent(partner.id)
                                                    }
                                                    .padding(.top, 8)
                                                    
                                                }
                                            }
                                            Spacer()
                                        }
                                        .padding(.horizontal, 16)
                                        
                                    }
                                    VStack {
                                        Button(action: {
                                            showCertifiedOrCompatible = .certified
                                        }) {
                                            HStack {
                                                Image("meeCertifiedLogo").resizable().scaledToFit().frame(width: 20)
                                                BasicText(text:"Mee-certified?", color: Colors.meeBrand, size: 14, underline: true)
                                            }
                                        }
                                        Button(action: {
                                            showCertifiedOrCompatible = .compatible
                                        }) {
                                            HStack {
                                                Image("meeCompatibleLogo").resizable().scaledToFit().frame(width: 20)
                                                BasicText(text:"Mee-compatible?", color: Colors.meeBrand, size: 14, underline: true)
                                            }
                                        }
                                    }
                                    .padding(.bottom, 20)
                                    .padding(.top, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    
                                }
                                .background(Color.white)
                                
                            }
                            .ignoresSafeArea(.all)
                            .background(Color.white)
                            .frame(maxWidth: .infinity)
                        }
                        .navigationViewStyle(.stack)
                        .overlay {
                            WarningPopup(text: "This site is not Mee-certified. Your data does not have the extra protections provided by the Mee Human Information License.") {
                                showCompatibleWarning = false
                            }
                            .ignoresSafeArea(.all)
                            .opacity(showCompatibleWarning ? 1 : 0)
                        }
                    } else {
                        FirstRunPageWelcome() {
                            showWelcome = false
                        }
                    }
                }
            }
            
        }
        .onAppear {
            refreshPartnersList(true)
        }
        .onChange(of: existingPartnersWebApp) { newValue in
            refreshPartnersList(false)
        }
        .onChange(of: existingPartnersMobileApp) { newValue in
            refreshPartnersList(false)
        }
        .ignoresSafeArea(.all)
    }
}

struct MainViewPage: View {
    var tabItems = [TabBarItem(id: 0, Icon: Image("dashboardImage"), tabName: "Dashboard", Element: AnyView(DashboardView())),
                    TabBarItem(id: 1, Icon: Image("chatImage"), tabName: "Chat", Element: AnyView(DashboardView())),
                    TabBarItem(id: 2, Icon: Image("menuImage"), tabName: "Menu", Element: AnyView(DashboardView())),]
    
    var body: some View {
        //        TabBar(items: tabItems)
        ConsentsList()
        
        
    }
}
