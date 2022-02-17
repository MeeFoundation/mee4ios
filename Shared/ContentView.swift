//
//  ContentView.swift
//  Shared
//
//  Created by alex slobodeniuk on 15.02.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ConsentPage()
//        NavigationView {
//            ZStack {
//                Rectangle()
//                    .foregroundColor(Colors.background)
//                    .edgesIgnoringSafeArea(.all)
//                NavigationLink(
//                    destination: ConsentPage(),
//                    label: {
//                        Text("Consent Page")
//                    }
//                )
//                .font(.largeTitle)
//                .navigationTitle("")
//                .navigationBarTitleDisplayMode(.inline)
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
