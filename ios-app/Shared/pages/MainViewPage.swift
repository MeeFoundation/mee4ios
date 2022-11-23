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



struct MainViewPage: View {
    var tabItems = [TabBarItem(id: 0, Icon: Image("dashboardImage"), tabName: "Dashboard", Element: AnyView(DashboardView())),
                    TabBarItem(id: 1, Icon: Image("chatImage"), tabName: "Chat", Element: AnyView(DashboardView())),
                    TabBarItem(id: 2, Icon: Image("menuImage"), tabName: "Menu", Element: AnyView(DashboardView())),]
    
    var body: some View {
        //        TabBar(items: tabItems)
        ConsentsList()
        
        
    }
}
