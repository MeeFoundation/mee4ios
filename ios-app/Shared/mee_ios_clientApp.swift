//
//  mee_ios_clientApp.swift
//  Shared
//
//  Created by alex slobodeniuk on 15.02.2022.
//

import SwiftUI

@main
struct mee_ios_clientApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(StorageState())
                .environmentObject(NavigationState())
                .environmentObject(ConsentState())
                .environmentObject(ToastState())
        }
    }
}
