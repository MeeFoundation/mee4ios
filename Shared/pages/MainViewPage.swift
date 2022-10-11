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
    let showMenu: Bool
    let isDetailedView: Bool
    @Binding var selection: String?
    var onRemove: () -> Void
    init(partner: PartnersModel, showMenu: Bool = false, isDetailedView: Bool = false, selection: Binding<String?>, onRemove: @escaping () -> Void) {
        self.partner = partner
        self.showMenu = showMenu
        self._selection = selection
        self.onRemove = onRemove
        self.isDetailedView = isDetailedView
    }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        
        return HStack {
            AsyncImage(url: URL(string: partner.imageUrl), content: { phase in
                if let image = phase.image {
                    image.resizable().scaledToFit().aspectRatio(contentMode: ContentMode.fill)
                        .frame(width: 48, height: 48, alignment: .center)
                        .clipShape(Circle())
                } else {
                    Colors.gray
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
            if showMenu {
                Menu {
                    if !isDetailedView {
                        Button {
                            selection = partner.id
                        } label: {
                            Label{
                                BasicText(text: "Manage Context", size: 17)
                                    .padding(.vertical, 12)
                            } icon: {
                                Image("editIcon").resizable().scaledToFit().frame(height: 17)
                            }
                        }
                    }
                    
                    Button {
                        print("block")
                    } label: {
                        Label{
                            BasicText(text: "Block Context", size: 17)
                                .padding(.vertical, 12)
                        } icon: {
                            Image("blockIcon").resizable().scaledToFit().frame(height: 17)
                        }
                    }
                    
                    Button(role: .destructive) {
                        onRemove()
                        if (isDetailedView) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        
                    } label: {
                        Label{
                            BasicText(text: "Forget Context", color: Colors.error, size: 17)
                            .padding(.vertical, 12)                        } icon: {
                                Image("trashIcon").resizable().scaledToFit().frame(height: 17)
                            }
                    }
                } label: {
                    Button(action: {
                        
                    }) {
                        HStack {
                            Spacer()
                            Image("dotsImage").resizable().scaledToFit()
                                .frame(width: 16)
                        }
                        .frame(width: 48, height: 48)
                    }
                }
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

struct PartnerDetails: View {
    let partner: PartnersModel
    var onRemove: () -> Void
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
                        }
                        .padding(.leading, 9)
                    }
                    Spacer()
                    BasicText(text: "Manage Context", color: .black ,size: 17, fontName: FontNameManager.PublicSans.semibold)
                        .padding(.trailing, 69)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 59)
                .padding(.bottom, 10)
                .background(Colors.backgroundAlt1)
                .shadow(color: Color.black.opacity(0.3), radius: 0, x: 0, y: 0.5)
                ScrollView {
                    PartnerEntry(partner: partner, showMenu: true, isDetailedView: true, selection: $selection) {
                        onRemove()
                    }
                    .border(Colors.meeBrand, width: 2)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 48)
                    .padding(.top, 16)
                    Expander(title: "Required info shared", isOpen: $isRequiredOpen) {
                        ForEach($consentEntries.filter {$0.wrappedValue.isRequired}) { $entry in
                            VStack {
                                ConsentEntry(entry: $entry)
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
                                    ConsentEntry(entry: $entry)
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
                }
                
                
            }
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                .onAppear{
                    let consentDataString = keychain.getItemByName(name: partner.id)
                    if let consentDataString {
                        let consentData = (consentDataString.fromBase64() ?? "").data(using: .utf8)!
                        do {
                            consentEntries = try JSONDecoder().decode([ConsentEntryModel].self, from: consentData)
                        } catch {
                            
                        }
                        
                        
                    }
                    
                }
            
        )
    }
}

struct ConsentsList: View {
    let keychain = KeyChainConsents()
    @EnvironmentObject var data: PartnersState
    @State var selection: String? = nil
    @State var existingPartners: [PartnersModel]?
    @State var otherPartners: [PartnersModel]?
    @State var showWelcome: Bool?
    func removeConsent(_ id: String) {
        if let partnerIndex = existingPartners?.firstIndex(where: { p in
            p.id == id
        }) {
            keychain.removeItembyName(name: id)
            existingPartners?.remove(at: partnerIndex)
        }
    }
    
    var body: some View {
        
        ZStack {
            
            if showWelcome != nil {
                if showWelcome == false {
                    NavigationView {
                        ZStack {
                            VStack {
                                ZStack {
                                    BasicText(text: "Contexts", color: .black ,size: 17, fontName: FontNameManager.PublicSans.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 59)
                                .padding(.bottom, 10)
                                .background(Colors.backgroundAlt1)
                                .shadow(color: Color.black.opacity(0.3), radius: 0, x: 0, y: 0.5)
                                VStack {
                                    if !(existingPartners ?? []).isEmpty {HStack {
                                        BasicText(text: "Sites and Apps", color: Colors.text, size: 16, fontName: FontNameManager.PublicSans.medium)
                                        Spacer()
                                    }
                                    .padding(.leading, 4)
                                    .padding(.top, 24)
                                    .padding(.bottom, 4)
                                    }
                                    ForEach(existingPartners ?? []) { partner in
                                        NavigationLink(destination: PartnerDetails(partner: partner, onRemove: {
                                            removeConsent(partner.id)
                                        }), tag: partner.id, selection: $selection){}
                                        PartnerEntry(partner: partner, showMenu: true, selection: $selection) {
                                            removeConsent(partner.id)
                                        }
                                        
                                    }
                                    if !(otherPartners ?? []).isEmpty {
                                        HStack {
                                            BasicText(text: "Other Sites and Apps You Might Like", color: Colors.text, size: 16, fontName: FontNameManager.PublicSans.medium)
                                            Spacer()
                                        }
                                        .padding(.leading, 4)
                                        .padding(.top, 24)
                                        .padding(.bottom, 4)
                                    }
                                    
                                    ForEach(otherPartners ?? []) { partner in
                                        PartnerEntry(partner: partner, selection: $selection) {
                                            
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                
                            }
                            .background(Color.white)
                            
                        }
                        .ignoresSafeArea(.all)
                        .background(Color.white)
                        .frame(maxWidth: .infinity)
                    }
                    .navigationViewStyle(.stack)
                } else {
                    FirstRunPageWelcome() {
                        showWelcome = false
                    }
                }
            }
        }
        .onAppear {
            existingPartners = data.partners.filter{ partner in
                keychain.getItemByName(name: partner.id) != nil
            }
            if existingPartners == nil || existingPartners!.isEmpty {
                showWelcome = true
            } else {
                showWelcome = false
            }
            otherPartners = data.partners.filter{ partner in
                keychain.getItemByName(name: partner.id) == nil
            }
        }
        
    }
}

struct MainViewPage: View {
    let keychain = KeyChainConsents()
    var tabItems = [TabBarItem(id: 0, Icon: Image("dashboardImage"), tabName: "Dashboard", Element: AnyView(DashboardView())),
                    TabBarItem(id: 1, Icon: Image("chatImage"), tabName: "Chat", Element: AnyView(DashboardView())),
                    TabBarItem(id: 2, Icon: Image("menuImage"), tabName: "Menu", Element: AnyView(DashboardView())),]
    
    var body: some View {
        //        TabBar(items: tabItems)
        ConsentsList()
        
    }
}
