//
//  Buttons.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 18.02.2022.
//

import SwiftUI


struct MainButton: View {
    var label: () -> Label
    var action: @escaping () -> Void
    var body: some View {
        Button(action: {}){
            Link("APPROVE", destination: URL(string: "http://localhost:3000/?interest=sweets")!)
        }
        .padding()
        .foregroundColor(Colors.mainButtonColor)
    }
}
