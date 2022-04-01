//
//  urlTools.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 16.03.2022.
//

import Foundation

func getFaviconLinkFromUrl (urlString: String?) -> String {
    let url = URL(string: urlString ?? "")
    let host = url?.host ?? ""
    let hostname = "https://\(host)/favicon.ico"
    return hostname
}
