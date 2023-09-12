//
//  PartnerEntry.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct PartnerEntry: View  {
    let connection: Connection
    let hasEntry: Bool
    let isCertified: Bool
    let clientMetadata: PartnerMetadata?
    let logoUri: URL?
    let name: String
    let hostname: String
    
    init(connection: Connection, hasEntry: Bool = false) {
        self.connection = connection
        self.hasEntry = hasEntry
        self.isCertified = true
        switch (connection.value) {
        case .Siop(let value):
            self.clientMetadata = value.clientMetadata
            self.name = clientMetadata?.name ?? connection.name
            self.logoUri = URL(string: clientMetadata?.logoUrl ?? "\(connection.id)/favicon.ico")
            self.hostname = connection.id.getHostname()
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
        }

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
        
        
    }
    
}
