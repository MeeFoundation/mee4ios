//
//  ConsentPage.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 16.02.2022.
//

import SwiftUI
import Foundation

struct ConsentPage: View {
    var isLocked: Bool
    @StateObject private var viewModel = ConsentPageViewModel()
    @EnvironmentObject var data: ConsentState
    @EnvironmentObject var navigationState: NavigationState
    @EnvironmentObject var appState: AppState
    @Environment(\.openURL) var openURL
    @AppStorage("recoveryPassphrase") var recoveryPassphrase: String?
    @AppStorage("hadConnectionsBefore") var hadConnectionsBefore: Bool = false
    var webService = WebService()
    @EnvironmentObject var core: MeeAgentStore

    var body: some View {
        ZStack {
            if !isLocked {
                if let isReturningUser = viewModel.isReturningUser {
                    if isReturningUser {
                        ConsentPageExisting() {id, url in
                            Task.init {
                                await viewModel.recoverRequest(id: id, url: url, data: data.consent)
                            }
                        }
                    }
                    else {
                        ConsentPageNew(){d in
                            Task.init {
                                await viewModel.authorizeRequest(d)
                            }
                        }
                    }
                }
            }
            
        }
        .onAppear{
            viewModel.setup(appState: appState, navigationState: navigationState, data: data, hadConnectionsBefore: hadConnectionsBefore, openURL: { url in
                openURL(url)
            }, core: core, webService: webService)
        }
        .onTapGesture {
            keyboardEndEditing()
        }
    }
}

