//
//  StorageListItem.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 16.03.2022.
//

import SwiftUI

struct StorageListItem: View {
    var index: Int
    @EnvironmentObject private var storageState: StorageState
    var body: some View {
        NavigationLink(destination:
            StorageItemDetails(
                item: storageState.passwords[index],
                removeEntry: {
                    
                },
                saveEntry: {item in
                    storageState.passwords[index] = item
                }
            )) {
                    HStack {
                        AsyncImage(url: URL(string: getFaviconLinkFromUrl(urlString: storageState.passwords[index].url)))
                        { image in
                            image.resizable().scaledToFit().aspectRatio(contentMode: ContentMode.fill)
                        } placeholder: {
                            Image(systemName: "key.fill")
                                .foregroundColor(Colors.text)
                        }
                            .frame(width: 20, height: 20)
                        BasicText(text: storageState.passwords[index].name ?? "")
                        Spacer()

                    }
            }
    }
}
