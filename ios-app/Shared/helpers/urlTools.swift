//
//  urlTools.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 16.03.2022.
//

import Foundation

func getFaviconLinkFromUrl (urlString: String?) -> String {
    if let urlString {
        if let url = URL(string: urlString) {
            if let host = url.host {
                let hostname = "https://\(host)/favicon.ico"
                return hostname
            }
        }
    }
    return ""
}
