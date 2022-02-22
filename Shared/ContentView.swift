//
//  ContentView.swift
//  Shared
//
//  Created by alex slobodeniuk on 15.02.2022.
//

import SwiftUI

enum CurrentPage: Hashable {
  case home, consent
}

struct ContentView: View {
    @State var currentPage:CurrentPage?
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
                            , tag: CurrentPage.consent
                            , selection: $currentPage
                        ){
                            Text("Consent Page")
                                .font(.largeTitle)
                        }
                            NavigationLink(
                            destination: LoginPage()
                        ){
                            Text("Login")
                                .font(.largeTitle)
                                .padding(.top, 10.0)
                        }
                        NavigationLink(
                            destination: SignUpPage()
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
                            currentPage = CurrentPage.consent
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
