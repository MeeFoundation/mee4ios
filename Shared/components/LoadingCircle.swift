//
//  LoadingCircle.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 11.07.2022.
//

import SwiftUI

struct LoadingCircle: View {
    var progress: CGFloat
    var width: CGFloat
    var height: CGFloat
    var body: some View {
        Circle()
            .stroke(Color.black.opacity(0), lineWidth: 3)
            .frame(width: width, height: height, alignment: .center)
            .padding(24)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Colors.background, lineWidth: 3)
                .frame(width: width, height: height, alignment: .center)
                .padding(24)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        
    }
}
