//
//  CurrentPage.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 02.03.2022.
//

import Foundation
import SwiftUI

class NavigationState: ObservableObject {
    @Published var currentPage:NavigationPages? = .mainPage
    @Published var payload: String? = nil

}

