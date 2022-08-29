//
//  SecureInputField.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 21.02.2022.
//

import SwiftUI

struct MainButton: View {
    private var action: () -> Void
    private var title: String
    private var image: Image?
    private var fullWidth: Bool?
    private var width: CGFloat?
    private var isDisabled: Bool?
    
    private var color: Color
    
    init(_ title: String, action: @escaping () -> Void, image: Image? = nil, fullWidth: Bool? = false, width: CGFloat? = nil, isDisabled: Bool? = false) {
        self.title = title
        self.action = action
        self.image = image
        self.fullWidth = fullWidth
        self.width = width
        self.isDisabled = isDisabled
        self.color = isDisabled! ? Colors.inactive : Colors.mainButtonTextColor
    }
    
    var body: some View {
        Button(action: action)
            {
                HStack {
                    if fullWidth! {Spacer()}
                    image?.resizable().scaledToFit()
                    BasicText(text: title, color: color, size: 20, fontName: FontNameManager.PublicSans.semibold)
                    if fullWidth! {Spacer()}
                }
            }
            .frame(width: width)
            .padding(20)
            .background(Colors.mainButtonBgColor)
            .cornerRadius(10)
            .disabled(isDisabled!)
    }
}

struct LinkButton: View {
    private var action: () -> Void
    private var title: String
    private var isDisabled: Bool?
    
    private var color: Color
    
    init(_ title: String, action: @escaping () -> Void, isDisabled: Bool? = false) {
        self.title = title
        self.action = action
        self.color = isDisabled! ? Colors.inactive : Colors.secondaryButtonBgColor
        self.isDisabled = isDisabled
    }
    
    var body: some View {
        Button(action: action)
            {
                HStack {
                    BasicText(text: title, color: color, size: 18, fontName: FontNameManager.PublicSans.medium, underline: true)
                }
            }
            .disabled(isDisabled!)
    }
}

struct DestructiveButton: View {
    private var action: () -> Void
    private var title: String
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action)
            {
                Text(title)
                    .foregroundColor(.red)
                    .font(.custom(FontNameManager.PublicSans.medium, size: 18))
            }
            .padding()
            .foregroundColor(.red)
            
    }
}

struct SecondaryButton: View {
    private var action: () -> Void
    private var title: String
    private var image: Image?
    private var fullWidth: Bool?
    private var width: CGFloat?
    private var isDisabled: Bool?
    
    private var color: Color
    
    init(_ title: String, action: @escaping () -> Void, image: Image? = nil, fullWidth: Bool? = false, width: CGFloat? = nil, isDisabled: Bool? = false) {
        self.title = title
        self.action = action
        self.image = image
        self.fullWidth = fullWidth
        self.width = width
        self.isDisabled = isDisabled
        self.color = isDisabled! ? Colors.inactive : Colors.secondaryButtonTextColor
    }
    
    var body: some View {
        Button(action: action)
            {
                HStack {
                    if fullWidth! {Spacer()}
                    image?.resizable().scaledToFit()
                    BasicText(text: title, color: color, size: 18, fontName: FontNameManager.PublicSans.semibold)
                    if fullWidth! {Spacer()}
                }
            }
            .frame(width: width)
            .padding(15)
            .background(Colors.secondaryButtonBgColor)
            .cornerRadius(10)
            .disabled(isDisabled!)
    }
}

struct RejectButton: View {
    private var action: () -> Void
    private var title: String
    private var image: Image?
    private var fullWidth: Bool?
    private var width: CGFloat?
    private var isDisabled: Bool?
    private var withBorder: Bool?
    
    private var color: Color
    
    init(_ title: String, action: @escaping () -> Void, image: Image? = nil, fullWidth: Bool? = false, width: CGFloat? = nil, isDisabled: Bool? = false, withBorder: Bool? = false) {
        self.title = title
        self.action = action
        self.image = image
        self.fullWidth = fullWidth
        self.width = width
        self.isDisabled = isDisabled
        self.color = isDisabled! ? Colors.inactive : Colors.secondaryButtonBgColor
        self.withBorder = withBorder
    }
    var body: some View {
        Button(action: action)
            {
                HStack {
                    if fullWidth! {Spacer()}
                    image?.resizable().scaledToFit()
                    BasicText(text: title, color: color, size: 18, fontName: FontNameManager.PublicSans.semibold)
                    if fullWidth! {Spacer()}
                }
            }
            .frame(width: width)
            .padding(15)
            .background(Colors.secondaryButtonTextColor)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Colors.secondaryButtonBgColor, lineWidth: withBorder! ? 5 : 0)
                )
            .cornerRadius(10)
            .disabled(isDisabled!)
    }
}

struct AddButton: View {
    private var action: () -> Void
    
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: action)
            {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Colors.mainButtonTextColor)
                    .background(Colors.secondaryButtonBgColor)
                    .clipShape(Circle())
            }
            .padding()
            .foregroundColor(Colors.mainButtonTextColor)
    }
}

struct DelayedActionButton: View {
    let title: String
    let action:  () -> Void
    let delay: CGFloat
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var progress: CGFloat = 0

    var body: some View {
        Button(action: action)
            {
                HStack {
                    Spacer()
                    Image("roundIcon").resizable().frame(width: 18, height: 18)
                        .overlay(BasicText(text: "\(Int(delay - progress))", color: .white, size: 12, fontName: FontNameManager.PublicSans.medium), alignment: .center)
                    BasicText(text: title, color: Colors.secondaryButtonTextColor, size: 18, fontName: FontNameManager.PublicSans.semibold)
                    Spacer()
                }
            }
            .padding(15)
            .background(Colors.secondaryButtonBgColor)
            .cornerRadius(10)
            .onReceive(timer) { time in
                print("\(Int(delay - progress))")
                if progress >= delay {
                    timer.upstream.connect().cancel()
                    if progress == delay {
                        action()
                    }
                    
                }
                if progress < delay {
                    progress += 1
                }
            }
    }
}
