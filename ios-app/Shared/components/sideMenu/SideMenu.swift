//
//  SideMenu.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 2.10.23..
//

import SwiftUI

struct MenuItem: Identifiable {
    var id: String {
        return self.text
    }
    let icon: String
    let text: String
    let action: () -> Void
}

struct SideMenu: View {
    let onClickOutside: () -> Void
    @EnvironmentObject var navigationState: NavigationState
    
    
    var body: some View {
        let menuItems: [MenuItem] = [
            MenuItem(icon: "settingsIcon", text: "Settings", action: {
                navigationState.currentPage = .settings
                onClickOutside()
                
            }),
            MenuItem(icon: "sendFeedback", text: "Send Feedback", action: openFeedbackUrl)]
        HStack {
            VStack {
                ForEach(menuItems) { item in
                    SideMenuItem(imageName: item.icon, text: item.text, action: item.action)
                }
                Spacer()
            }
            .padding(.leading, 30)
            .padding(.top, 27)
            .frame(maxWidth: 320)
            .frame(maxHeight: .infinity)
            .background(.white)
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity)
    }
}

struct SideMenuItem: View {
    let imageName: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {

                    Image(imageName)
                    BasicText(text: text, size: 16, weight: .medium)
                Spacer()

            }
            .padding(.vertical, 10)
        }
        
        
    }
}
