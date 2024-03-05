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
    
    init(connection: MeeConnectionWrapper, hasEntry: Bool = false) {
        self.connection = connection
        self.hasEntry = hasEntry
        self.logoUri = URL(string: "https://\(connection.id)/favicon.ico")
        self.hostname = connection.id
        self.name = connection.name
//        switch (connector.connectorProtocol) {
//        case .Siop(let value):
//            self.clientMetadata = value.clientMetadata
//            self.name = clientMetadata?.name ?? connector.name
//            self.logoUri = URL(string: clientMetadata?.logoUrl ?? "\(connector.id)/favicon.ico")
//            hostname = value.redirectUri.getHostname() ?? value.redirectUri
//        case .Gapi(_):
//            self.clientMetadata = nil
//            self.name = "Google Account"
//            self.logoUri = URL(string: "https://google.com/favicon.ico")
//            hostname = "google.com"
//        case .MeeTalk:
//            self.clientMetadata = nil
//            self.name = "Mee Talk"
//            self.logoUri = URL(string: "https://mee.foundation/favicon.png")
//            hostname = "mee.foundation"
//        case .openId4Vc(value: let value):
//            self.clientMetadata = nil
//            self.name = "VC"
//            self.logoUri = nil
//            hostname = value.issuerUrl
//        case .MeeBrowserExtension:
//            self.clientMetadata = nil
//            self.name = "Extension"
//            self.logoUri = URL(string: "https://\(self.connector.otherPartyConnectionId)/favicon.ico")
//            hostname = self.connector.otherPartyConnectionId
//        }
        
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
            if hasEntry {
                HStack {
                    Spacer()
                    Image("arrowRight").resizable().scaledToFit()
                        .frame(width: 7)
                }
                .frame(width: 48, height: 48)
            }
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
