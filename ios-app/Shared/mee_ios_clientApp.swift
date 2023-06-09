//
//  mee_ios_clientApp.swift
//  Shared
//
//  Created by alex slobodeniuk on 15.02.2022.
//

import SwiftUI

@main
struct mee_ios_clientApp: App {
    @StateObject var navigation = NavigationState()
    @StateObject var consent = ConsentState()
    @StateObject var toast = ToastState()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(navigation)
                    .environmentObject(consent)
                    .environmentObject(toast)
            }
            
        }
    }
}
