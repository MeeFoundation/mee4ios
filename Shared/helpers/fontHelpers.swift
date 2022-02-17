//
//  fontHelpers.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 16.02.2022.
//

import Foundation;
import UIKit

func getFontNames() {
    for family in UIFont.familyNames {
           print("family:", family)
           for font in UIFont.fontNames(forFamilyName: family) {
               print("font:", font)
           }
       }
}

struct FontNameManager {
  struct PublicSans {
    static let light = "PublicSans-Light"
    static let regular = "PublicSans-Regular"
    static let bold = "PublicSans-Bold"
    static let medium = "PublicSans-Medium"
    static let semibold = "PublicSans-SemiBold"
  }
}
