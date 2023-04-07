//
//  matchesRegex.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 4.4.23..
//

import Foundation

func matchesRegex(regex: String!, text: String!) -> Bool {
    do {
        let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
        let nsString = text as NSString
        let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
        return (match != nil)
    } catch {
        return false
    }
}
