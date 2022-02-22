//
//  ContentView.swift
//  Shared
//
//  Created by alex slobodeniuk on 15.02.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            NavigationView {
                ZStack {
                    Background()
                    VStack {
                        
                        NavigationLink(
                            destination: ConsentPage().onOpenURL { url in
                                print(url)
                            }
                            .navigationBarTitle("", displayMode: .inline)
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                        ){
                            Text("Consent Page")
                                .font(.largeTitle)
                        }
                        NavigationLink(
                            destination: LoginPage()
                        ){
                            Text("Login")
                                .font(.largeTitle)
                        }
                        NavigationLink(
                            destination: SignUpPage()
                        ){
                            Text("Sign Up")
                                .font(.largeTitle)
                        }
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
