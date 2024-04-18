//
//  PartnerEntry.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct PartnerEntry: View  {
    let connection: MeeConnectionWrapper
    let hasEntry: Bool
    let logoUri: URL?
    let name: String
    let hostname: String
    @EnvironmentObject var core: MeeAgentStore
    let onConnectionRemove: () -> Void
    
    init(connection: MeeConnectionWrapper, hasEntry: Bool = false, onConnectionRemove: (() -> Void)?) {
        self.connection = connection
        self.hasEntry = hasEntry
        self.logoUri = URL(string: "https://\(connection.id)/favicon.ico")
        self.hostname = connection.id
        self.name = connection.name
        self.onConnectionRemove = onConnectionRemove ?? {}
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        
        return HStack {
            AsyncImageRounded(url: logoUri)
            
            
            VStack {
                HStack {
                    Text(name)
                        .foregroundColor(Colors.text)
                        .font(.custom(FontNameManager.PublicSans.medium , size: 16))
                    //                        Image(isCertified ? "meeCertifiedLogo" : "meeCompatibleLogo").resizable().scaledToFit().frame(width: 20)
                    Spacer()
                }
                
                BasicText(text: hostname, color: Colors.text, size: 12, align: .left, fontName: FontNameManager.PublicSans.regular)
            }
            .padding(.leading, 8)
            Spacer()
            
                HStack {
                    Spacer()
                    if hasEntry {
                        Image("arrowRight").resizable().scaledToFit()
                            .frame(width: 7)
                    } else {
                        Menu {
                            Button {
                                onConnectionRemove()
                            } label: {
                                Label {
                                    BasicText(text: "Delete Connection", color: Colors.error, size: 17)
                                } icon: {
                                    Image("trashIcon").resizable().scaledToFit()
                                        .frame(width: 24)
                                }
                            }
                        } label: {
                            Image("connectionMenuIcon").resizable().scaledToFit()
                                .frame(width: 24)
                                .padding(.trailing, 9)
                        }
                    }
                }
                .frame(width: 48, height: 48)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .padding(.leading, 8)
        .padding(.trailing, 9)
        .background(Colors.gray100)
        .onAppear {
//            Task {
//                switch (connector.connectorProtocol) {
//                case .Gapi(_):
//                    let contextData = await core.getLastExternalConsentByConnectorId(connectorId: connector.id)
//                    if case let .gapi(gapiData) = contextData?.data {
//                        displayedHostname = gapiData.userInfo.email ?? ""
//                    }
//                default:
//                    displayedHostname = hostname
//                }
//            }
            
        }
        
    }
        
}
