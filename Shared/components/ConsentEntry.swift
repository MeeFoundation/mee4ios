//
//  ConsentEntry.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.02.2022.
//

import SwiftUI

struct ConsentEntry: View {
    var entry: ConsentEntryModel
    @State var isOn = true
    @State var isOpen = false
    @State var value: String?
    init (consentEntry: ConsentEntryModel) {
        self.entry = consentEntry
        value = self.entry.value
    }
    var body: some View {
        VStack{
            HStack {
                Image(getConsentEntryImageByType(entry.type)).resizable().scaledToFit()
                    .frame(width: 18, height: 18, alignment: .center)
                    .padding(.trailing, 13)
                Button(action: {
                    if (entry.hasValue) {
                        isOpen = !isOpen
                    }
                }) {
                    Text(entry.name)
                    .foregroundColor(Colors.meeBrand)
                    .font(.custom(FontNameManager.PublicSans.regular, size: 18))
                }
                
                Spacer()
            }
            if isOpen {
                Group {
                    TextField(entry.name, text:  optionalBinding(binding: $value))
                        .frame(height: 48)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 6))
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 1.0)
                        )
                }
                .padding(.horizontal, 10.0)
                .padding(.top, 15.0)
            }
        }
        .padding(.bottom, 8.0)
    }
}

//struct Previews_ConsentEntry_Previews: PreviewProvider {
//    static var previews: some View {
//        ConsentEntry(consentEntry: ConsentEntryModel(name: "First Name", isRequired: true, canRead: true)
//        )
//    }
//}
