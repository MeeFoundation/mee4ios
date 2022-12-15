//
//  TabBar.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 7.9.22..
//

import SwiftUI

struct TabBarElement: View {
    var index: Int
    var Icon: Image
    var tabName: String
    var onClick: (_ newTab: Int) -> Void
    var body: some View {
        Button(action: {
            onClick(index)
        }) {
            VStack(spacing: 0) {
                
                    Icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .padding(.top, 15)
                        .foregroundColor(.white)
                    Text(tabName)
                        .font(.custom(FontNameManager.PublicSans.medium, size: 12))
                        .foregroundColor(.white)
                        .padding(.bottom, 31)
                        .padding(.top, 3)
            }
            .frame(maxWidth: 75)
        }
    }
}

struct TabBar: View {
    var items: [TabBarItem]
    @State var selectedTab = 0
     var body: some View {
         VStack(alignment:.leading, spacing: 0) {
             ZStack {
                 if let i = items.firstIndex(where: { $0.id == selectedTab }) {
                     items[i].Element
                 }
             }
             HStack(spacing: 0) {
                 Spacer()
                 ForEach(items) { item in
                     TabBarElement(index: item.id, Icon: item.Icon, tabName: item.tabName) {newValue in
                         selectedTab = newValue
                     }
                     Spacer()
                 }
                 
             }
             .frame(height: 83)
             .background(Colors.meeBrand)
         }.edgesIgnoringSafeArea(.all)
             .background(.black)
         
    }
 }

struct TabBarItem: Identifiable {
    var id: Int
    var Icon: Image
    var tabName: String
    var Element: AnyView
}
