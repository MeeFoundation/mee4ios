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
                .onAppear(){
                    let result = rust_hello("world")
                    let swift_result = String(cString: result!)
                    rust_hello_free(UnsafeMutablePointer(mutating: result))
                    print(swift_result)
                }
        }
    }
}
