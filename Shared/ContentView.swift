//
//  ContentView.swift
//  Shared
//
//  Created by alex slobodeniuk on 15.02.2022.
//

import SwiftUI

enum NavigationPages: Hashable {
  case home, consent, signUp, login
}

struct ContentView: View {

    @StateObject var navigationState = NavigationState()
    
    var body: some View {
            NavigationView {
                ZStack {
                    Background()
                    VStack {
                        
                        NavigationLink(
                            destination: ConsentPage()
                            .navigationBarTitle("", displayMode: .inline)
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                            ,tag: NavigationPages.consent
                            ,selection: $navigationState.currentPage
                        ){
                            Text("Consent Page")
                                .font(.largeTitle)
                        }
                            NavigationLink(
                                destination: LoginPage(navigationState: navigationState)
                            ,tag: NavigationPages.login
                            ,selection: $navigationState.currentPage
                        ){
                            Text("Login")
                                .font(.largeTitle)
                                .padding(.top, 10.0)
                        }
                        NavigationLink(
                            destination: SignUpPage()
                            ,tag: NavigationPages.signUp
                            ,selection: $navigationState.currentPage
                        ){
                            Text("Sign Up")
                                .font(.largeTitle)
                                .padding(.top, 10.0)
                        }
                    }
                }
                
            }
            .onOpenURL { url in
                if (url.host != nil) {
                    switch (url.host) {
                        case "consent":
                        navigationState.currentPage = NavigationPages.consent
                        default: break
                        
                    }
                }
            }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
