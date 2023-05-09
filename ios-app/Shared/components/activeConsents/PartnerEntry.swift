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
    init(connection: Connection, hasEntry: Bool = false) {
        self.connection = connection
        self.hasEntry = hasEntry
        self.isCertified = true
        if case let .Siop(value) = connection.value {
            self.clientMetadata = value.clientMetadata
        } else {
            clientMetadata = nil
        }
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        
        return HStack {
            AsyncImageRounded(url: URL(string: clientMetadata?.logoUrl ?? "\(connection.id)/favicon.ico"))
            
            
                VStack {
                    HStack {
                        Text(clientMetadata?.name ?? connection.name)
                            .foregroundColor(Colors.text)
                            .font(.custom(FontNameManager.PublicSans.medium , size: 16))
                        Image(isCertified ? "meeCertifiedLogo" : "meeCompatibleLogo").resizable().scaledToFit().frame(width: 20)
                        Spacer()
                    }
                    
                    BasicText(text: connection.id.getHostname(), color: Colors.text, size: 12, align: .left, fontName: FontNameManager.PublicSans.regular)
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
