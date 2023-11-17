//
//  SettingsPage.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 2.10.23..
//

import SwiftUI

struct SettingsPage: View {
    @EnvironmentObject private var navigationState: NavigationState
    @State var userDataRemovedDialog: Bool = false
    @State var userDataRemoveDialog: Bool = false
    @EnvironmentObject var core: MeeAgentStore
    
    var body: some View {
        VStack {
            Header(text: "Settings") {
                navigationState.currentPage = .mainPage
            }
                
            VStack {
                SettingsCategory(name: "Screen Lock Type")
                SettingsItem(imageName: "biometricsSettings", name: "Biometrics & Passcode", description: "Go to Security Settings") {
                    UIApplication.shared.open(URL(string: "App-prefs:PASSCODE")!)
                }
                Spacer()
                SettingsAction(imageName: "trashIcon", name: "Delete user data", onClick: {
                    userDataRemoveDialog = true
                })
            }.padding(.horizontal, 16).padding(.top, 16)
            
            
        }
        .ignoresSafeArea(edges: .top)
        .overlay {
            ZStack {
                BackgroundFaded()
                VStack {
                    Spacer()
                    ContinueDialog(imageName: "greenCheckmark", text: "All Set!", description: "Your data was deleted successfully", buttonText: "Back to Connections Screen", onNext: {
                        navigationState.currentPage = .mainPage
                        
                    })
                }
            }
            .opacity(userDataRemovedDialog ? 1 : 0)
            .ignoresSafeArea(edges: .bottom)
        }
        .overlay {
            ZStack {
                BackgroundFaded()
                VStack {
                    Spacer()
                    DestructionConfirmationDialog(text: "Delete user data", description: "Are you sure you want to delete your data?", buttonText: "Yes, delete my data", onNext: {
                        Task {
                            do {
                                try await core.removeAllData()
                                userDataRemovedDialog = true
                            } catch {
                                userDataRemoveDialog = false
                            }
                        }
                        
                    }, onCancel: {
                        userDataRemoveDialog = false
                    })
                }
            }
            .opacity(userDataRemoveDialog ? 1 : 0)
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct SettingsCategory: View {
    let name: String
    var body: some View {
        HStack{
            BasicText(text: name, size: 16, weight: .medium)
            Spacer()
        }
        
    }
}

struct SettingsItem: View {
    let imageName: String
    let name: String
    let description: String
    let onClick: () -> Void
    var body: some View {
        Button(action: onClick) {
            HStack {
                ZStack {
                    Image(imageName)
                }.frame(width: 48, height: 48).background(.white).cornerRadius(100)
                
                
                VStack {
                    BasicText(text: name, size: 16, align: .left, weight: .medium)
                    BasicText(text: description, size: 12, align: .left, weight: .regular)
                }
                .padding(.leading, 8)
                Spacer()
                Image("arrowRight")
            }.padding(.all, 8).background(Colors.gray100)
        }
        
    }
}


struct SettingsAction: View {
    let imageName: String
    let name: String
    let onClick: () -> Void
    var body: some View {
        Button(action: onClick) {
            HStack {
                BasicText(text: name, color: Colors.error, size: 16, align: .left, weight: .medium)
                    .padding(.leading, 8)
                Spacer()
                Image(imageName).resizable().frame(width: 24, height: 24)
            }
            .padding(.vertical, 11)
            .padding(.horizontal, 16)
            .background(.white.opacity(0.5))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.2), radius: 32, x: 0, y: 8)
        }
        .padding(.bottom, 30)
        
    }
}
