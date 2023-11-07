//
//  mee_ios_clientApp.swift
//  Shared
//
//  Created by alex slobodeniuk on 15.02.2022.
//

import SwiftUI
import UIKit
import BackgroundTasks

@main
struct mee_ios_clientApp: App, MeeAgentStoreErrorListener {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        
    }
    @StateObject var navigation = NavigationState()
    @StateObject var consent = ConsentState()
    @StateObject var appState = AppState()

    var id = UUID()
    
    
    
    @State var error: AppErrorRepresentation? = nil
    
    func onError(error: AppErrorRepresentation) {
        self.error = error
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(navigation)
                    .environmentObject(consent)
                    .environmentObject(appState)
                    .environmentObject(appDelegate.core)
            }
            .overlay {
                ZStack {
                    BackgroundFaded()
                    VStack {
                        Spacer()
                        UnrecoverableErrorDialog(error: error)
                    }
                }
                .opacity(error != nil ? 1 : 0)
                .ignoresSafeArea(edges: .bottom)
                
            }
            .onAppear {
                error = appDelegate.core.error
                appDelegate.core.addErrorListener(self)
            }

        }
    }
      
}

