//
//  TourPage.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 30.3.23..
//

import SwiftUI

struct TourPage: View {
    var images: [String]
    var onSkip: () -> Void
    @State private var selection: String
    
    
    init(images: [String], onSkip: @escaping () -> Void) {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Colors.meeBrand)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Colors.meeBrand.opacity(0.5))
        UITabBar.appearance().backgroundColor = UIColor(Colors.meeBrandYellow)
        self.images = images
        self.onSkip = onSkip
        self.selection = images[0]
    }
    
    
    func changeTab(currentTab: String, jump: Int) {
        let currentIndex = images.firstIndex {
            $0 == currentTab
        }
        if let currentIndex {
            let newIndex = currentIndex + jump
            print(currentIndex, newIndex, jump, images.count)
            if newIndex >= 0 && newIndex < images.count {
                selection = images[newIndex]
            }
            
        }
    }
    
    var body: some View {
        Colors.meeBrandYellow.overlay(
            VStack {
                TabView(selection: $selection) {
                    ForEach(images, id: \.self) { imageName in
                        TourFragment(imageName: imageName, skipButtonInvisible: imageName == images[images.count - 1], onSkip: onSkip)
                            .tabItem {
                                selection == imageName ? VStack {
                                    Image("bulletFilled")
                                } : VStack {
                                    Image("bulletEmpty")
                                }
                                
                            }
                            .tag(imageName)
                    }
                    
                }
                .overlay(alignment: .bottom) {
                    HStack {
                        if selection != images[0] {
                            Button(action: {
                                print("fired <")
                                changeTab(currentTab: selection, jump: -1)
                            }) {
                                Image("swipeLeft")
                                    .padding(.horizontal, 33)
                                    .padding(.vertical, 10)
                            }
                            
                        }
                        Spacer()
                        if selection != images[images.count - 1] {
                            Button(action: {
                                print("fired >")
                                changeTab(currentTab: selection, jump: 1)
                            }) {
                                Image("swipeRight")
                                    .padding(.horizontal, 33)
                                    .padding(.vertical, 10)
                            }
                        }
                        
                    }
                    
                }
                .accentColor(Colors.meeBrand)
                
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(.page(backgroundDisplayMode: .never))
                HStack {
                    Colors.meeBrandYellow.ignoresSafeArea(.all)
                }
                .foregroundColor(Colors.meeBrandYellow)
                .frame(height: 36)
            }
            
                .foregroundColor(Colors.meeBrandYellow)
                .ignoresSafeArea(.all)
        )
        .ignoresSafeArea(.all)
    }
}

struct TourFragment: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    let imageName: String
    let skipButtonInvisible: Bool
    let onSkip: () -> Void
    
    var body: some View {
        ZStack {
            BackgroundYellow()
            VStack(spacing: 0) {
                Image(imageName).resizable().scaledToFit()
                    .overlay(VStack(spacing: 0) {
                    }.padding(.top, sizeClass == .compact ? 60 :  100)
                             , alignment: .top)
                VStack {
                    if skipButtonInvisible {
                        RejectButton("Get Started", action: onSkip, fullWidth: true, withBorder: true)
                            .padding(.horizontal, 10)
                    }
                }
                .frame(height: 51)
                
                Spacer()
            }
            .padding(.top, 30)
            .padding(.horizontal, 6)
            .padding(.bottom, 36)
            
        }
    }
}

//struct TutorialPagePreviews: PreviewProvider {
//
//  static var previews: some View {
//      TourPage(images: ["meeWelcome1", "meeWelcome2"]) {
//
//      }
//  }
//}
