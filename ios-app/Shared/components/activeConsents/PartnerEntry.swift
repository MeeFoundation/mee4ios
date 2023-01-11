//
//  PartnerEntry.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct PartnerEntry: View  {
    let partner: PartnerData
    let hasEntry: Bool
    let isCertified: Bool
    init(partner: PartnerData, hasEntry: Bool = false) {
        self.partner = partner
        self.hasEntry = hasEntry
        self.isCertified = CertifiedPartnersState.shared.partners.firstIndex{p in partner.client_id == p.client_id} != nil
    }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        
        return HStack {
            AsyncImage(url: URL(string: partner.logoUrl), content: { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFit().aspectRatio(contentMode: ContentMode.fill)
                            .frame(width: 48, height: 48, alignment: .center)
                            .clipShape(Circle())
                    } else {
                        ProgressView()
                    }
                    
                })
                .frame(width: 48, height: 48)
                
                VStack {
                    HStack {
                        Text(partner.name)
                            .foregroundColor(Colors.text)
                            .font(.custom(FontNameManager.PublicSans.medium , size: 16))
                        Image(isCertified ? "meeCertifiedLogo" : "meeCompatibleLogo").resizable().scaledToFit().frame(width: 20)
                        Spacer()
                    }
                    
                    BasicText(text: partner.displayUrl, color: Colors.text, size: 12, align: .left, fontName: FontNameManager.PublicSans.regular)
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
