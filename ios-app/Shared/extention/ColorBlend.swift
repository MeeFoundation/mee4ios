//
//  ColorBlend.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 10.11.22..
//

import SwiftUI

public struct ColorBlended: ViewModifier {
  fileprivate var color: Color
  
  public func body(content: Content) -> some View {
    VStack {
      ZStack {
        content
        color.blendMode(.sourceAtop)
      }
      .drawingGroup(opaque: false)
    }
  }
}

extension View {
    public func blending(_ color: Color) -> some View {
        modifier(ColorBlended(color: color))
    }
}
