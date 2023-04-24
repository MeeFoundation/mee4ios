//
//  AsyncImageRounded.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 20.4.23..
//

import SwiftUI
import Kingfisher

struct AsyncImageRounded: View {
    
    let url: URL?
    
    var body: some View {
        KFImage.url(url)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .resizable()
            .scaledToFit()
            .aspectRatio(contentMode: ContentMode.fit)
            .frame(width: 48, height: 48, alignment: .center)
            .clipShape(Circle())
    }
}
