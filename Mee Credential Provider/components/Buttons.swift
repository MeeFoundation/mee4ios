//
//  Buttons.swift
//  Mee Credential Provider
//
//  Created by Anthony Ivanov on 29.03.2022.
//

import Foundation
import SwiftUI

struct ListButton: View {
    private var action: () -> Void
    private var title: String
    private var subtitle: String
    private var imageUrl: String?
    
    init(_ title: String,_ subtitle: String,_ imageUrl: String, action: @escaping () -> Void) {
        self.subtitle = subtitle
        self.title = title
        self.action = action
        self.imageUrl = imageUrl
    }
    
    private func unlockCallback(success: Bool) {
        if success {
            action()
        }
    }
    
    var body: some View {
        Button(action: {
            requestLocalAuthentication(unlockCallback)
        })
            {
                HStack{
                    AsyncImage(url: URL(string: getFaviconLinkFromUrl(urlString: imageUrl)))
                    { image in
                        image.resizable()
                    } placeholder: {
                        Image(systemName: "key.fill")
                            .foregroundColor(Colors.text)
                    }
                        .frame(width: 25, height: 25)
                    Spacer()
                    VStack {
                        Spacer()
                        Text(title)
                            .foregroundColor(Colors.text)
                            .font(.custom(FontNameManager.PublicSans.medium, size: 16))
                        Text(subtitle)
                            .foregroundColor(Colors.text)
                            .font(.custom(FontNameManager.PublicSans.light, size: 12))
                        Spacer()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.trailing, 20)
                    Spacer()
                }
                .frame(height: 32)
            }
            .buttonStyle(RoundedCorners(color: Colors.mainButtonTextColor, background: Colors.background.opacity(0)))
            .padding(.top, 10)
            .padding(.horizontal, 10)
    }
}

