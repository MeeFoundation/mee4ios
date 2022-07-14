//
//  PasswordManager.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 15.03.2022.
//

import SwiftUI

struct PasswordManagerPage: View {
    @State var selectedTab = Tabs.Passwords
    @State var showNewPasswordEntryModal = false
    @EnvironmentObject private var navigationState: NavigationState
    @EnvironmentObject private var storageState: StorageState
    init() {
        UITableViewCell.appearance().backgroundColor = UIColor(Colors.background)
        UITableView.appearance().backgroundColor = UIColor(Colors.background)
    }
        
        var body: some View {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        ZStack {
                            HStack {
                                Image(systemName: "key.fill")
                                    .foregroundColor(selectedTab == .Passwords ? Colors.mainButtonTextColor : Color.gray)
                                BasicText(text: "Passwords", color: selectedTab == .Passwords ? Colors.mainButtonTextColor : Color.gray, size: 14)
                            }
                            .onTapGesture {
                                self.selectedTab = .Passwords
                            }
                        }
                        Spacer()
                        HStack {
                            Image(systemName: "creditcard")
                                .foregroundColor(selectedTab == .CreditCards ? Colors.mainButtonTextColor : Color.gray)
                            BasicText(text: "Credit Cards", color: selectedTab == .CreditCards ? Colors.mainButtonTextColor : Color.gray, size: 14)
                        }
                        .onTapGesture {
                            self.selectedTab = .CreditCards
                        }
                        Spacer()
                    }
                    .background(Colors.background.edgesIgnoringSafeArea(.all))
                    .padding(.top, 25)
                    .padding(.bottom, 5)
                    
                    ZStack {
                        if selectedTab == .Passwords {
                            PasswordTabView()
                        } else if selectedTab == .CreditCards {
                            CreditCardsTabView()
                        }
                    
                    
                        VStack{
                            Spacer()
                            HStack {
                                Spacer()
                                AddButton() {
                                    
                                    showNewPasswordEntryModal = true
                                }
                                .padding(.horizontal, 20)
                                .sheet(isPresented: $showNewPasswordEntryModal, content: {
                                    StorageItemDetails(
                                        item: PasswordEntryModel(),
                                        removeEntry: {
                                            showNewPasswordEntryModal = false
                                        },
                                        saveEntry: {item in
                                            storageState.passwords.append(PasswordEntryModel())
                                            storageState.passwords[storageState.passwords.count - 1] = item
                                            showNewPasswordEntryModal = false
                                        },
                                        isNewEntry: true
                                    )
                                })
                            }
                        }
                    }
                    
                }
                .background(Colors.background)
            }
    }

    struct PasswordTabView : View {
        @EnvironmentObject private var storageState: StorageState

        var body : some View {
            ZStack {
                VStack {
                    List {
                        ForEach(storageState.passwords.indices, id: \.self) { (index) in
                            StorageListItem(index: index)
                        }
                    }
                    .onAppear(perform: {
                            UITableView.appearance().contentInset.top = -35
                        })
                }
            }
        }
    }

    struct CreditCardsTabView : View {
        
        var body : some View {
            Text("Credit Cards TAB VIEW")
        }
    }


    enum Tabs {
        case Passwords
        case CreditCards
    }
}
