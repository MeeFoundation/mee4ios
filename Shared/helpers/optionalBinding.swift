//
//  optionalBinding.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 10.03.2022.
//

import SwiftUI

func optionalBinding(binding: Binding<String?>, fallback: String? = "") -> Binding<String> {
  return Binding(get: {
    binding.wrappedValue ?? fallback!
  }, set: {
      binding.wrappedValue = $0 == "" ? nil : $0
  })
}
