//
//  PlusMenu.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 11.10.23..
//

import SwiftUI

struct PlusMenu: View {
    var availableItems: [MeeConnectorWrapper]
    @EnvironmentObject var core: MeeAgentStore
    @State var isDialogOpened: Bool = false
    @Environment(\.openURL) var openURL
    @State var showGoogleConnectionWarning: Bool = false
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    isDialogOpened = true
                }) {
                    Image("plusButtonIcon")
                }
            }
        }
        .overlay {
            ZStack {
                BackgroundFaded()
                VStack(spacing: 0) {
                    Spacer()
                    CustomCancellableDialog(text: "Sites/Apps to Connect to", onCancel: {
                        isDialogOpened = false
                    }) {
                        VStack {
                            ForEach(Array(availableItems.enumerated()), id: \.offset) {index, item in
                                PlusMenuItem(item: item, isLight: index % 2 == 0) {
                                    isDialogOpened = false
                                    switch (item.connectorProtocol) {
                                    case .Gapi(_):
                                        showGoogleConnectionWarning = true
                                    default:
                                        if let url = URL(string: item.id) {
                                            openURL(url)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
            .opacity(isDialogOpened ? 1 : 0)
        }
        .overlay {
            WarningPopup(text: "Log in to your Google account to retrieve your personal data held there and store it in this app.", iconName: "google", onNext: {
                showGoogleConnectionWarning = false
                Task.init {
                    await core.googleAuthRequest()
                }
                
            }, onClose: {
                showGoogleConnectionWarning = false
            })
            
            .ignoresSafeArea(.all)
            .opacity(showGoogleConnectionWarning ? 1 : 0)
        }
    }
}

struct PlusMenuItem: View {
    @EnvironmentObject var core: MeeAgentStore
    var item: MeeConnectorWrapper
    let clientMetadata: PartnerMetadata?
    let logoUri: URL?
    let name: String
    let hostname: String
    let isLight: Bool
    let onItemClick: () -> Void
    
    init(item: MeeConnectorWrapper, isLight: Bool, onItemClick: @escaping () -> Void) {
        self.item = item
        self.isLight = isLight
        self.onItemClick = onItemClick
        switch (item.connectorProtocol) {
        case .Siop(let value):
            self.clientMetadata = value.clientMetadata
            self.name = clientMetadata?.name ?? item.name
            self.logoUri = URL(string: clientMetadata?.logoUrl ?? "\(item.id)/favicon.ico")
            self.hostname = value.redirectUri.getHostname() ?? value.redirectUri
        case .Gapi(_):
            self.clientMetadata = nil
            self.name = "Google Account"
            self.logoUri = URL(string: "https://google.com/favicon.ico")
            self.hostname = "google.com"
        case .MeeTalk:
            self.clientMetadata = nil
            self.name = "Mee Talk"
            self.logoUri = URL(string: "https://mee.foundation/favicon.png")
            self.hostname = "mee.foundation"
        case .openId4Vc(value: let value):
            self.clientMetadata = nil
            self.name = "VC"
            self.logoUri = nil
            self.hostname = value.issuerUrl
        case .MeeBrowserExtension:
            self.clientMetadata = nil
            self.name = "Extension"
            self.logoUri = nil
            self.hostname = ""
        }
        
    }
    
    
    var body: some View {
        HStack {
            AsyncImageRounded(url: logoUri)
            Text(name)
                .foregroundColor(Colors.text)
                .font(.custom(FontNameManager.PublicSans.medium , size: 16))
                .padding(.leading, 8)
            Spacer()
            Button(action: onItemClick) {
                BasicText(text: "Connect", color: Colors.mainButtonTextColor, size: 12)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .padding(.leading, 8)
        .padding(.trailing, 9)
        .background(isLight ? Colors.gray100 : Colors.gray100.opacity(0))
        
    }
}
