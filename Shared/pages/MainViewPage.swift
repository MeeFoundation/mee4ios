//
//  PasswordManager.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 15.03.2022.
//

import SwiftUI

struct MainViewPage: View {
    @State var selectedTab: MainViewTabs
    func getNavBarTitleText () -> String {
        switch selectedTab {
            case MainViewTabs.Storage:
                return "Storage"

            case MainViewTabs.Profile:
                return "Profile"
            
            case MainViewTabs.Mfa:
                return "2FA"
        }
    }
   
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Colors.background)
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Colors.text)]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(Colors.text)]
        self.selectedTab = MainViewTabs.Storage
    }
    var body: some View {
        TabView(selection: $selectedTab) {
            PasswordManagerPage()
//                .badge(1)
                .tag(MainViewTabs.Storage)
                .tabItem {
                    Image(systemName: "key.fill").renderingMode(.template)
                    BasicText(text: "Storage")
                }
            VStack {
                Text("Profile")
                Spacer()
            }
            .tag(MainViewTabs.Profile)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
            Text("2FA")
                .tag(MainViewTabs.Mfa)
                .tabItem {
                    Image(systemName: "iphone.homebutton")
                    Text("2FA")
                }
        }
        .accentColor(Colors.mainButtonTextColor)
        .background(Colors.background.edgesIgnoringSafeArea(.all))
        .navigationBarTitle(getNavBarTitleText())
        .navigationBarBackButtonHidden(true)
        
    }
    enum MainViewTabs {
        case Storage
        case Profile
        case Mfa
    }
}
