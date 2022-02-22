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
    @State var value = ""
    init (consentEntry: ConsentEntryModel) {
        self.entry = consentEntry
        value = self.entry.value
    }
    var body: some View {
        VStack{
            HStack {
                Toggle(isOn: $isOn) {
 
                }
                .frame(width: 60)
                .disabled(entry.isRequired)
                Button(action: {
                    if (entry.hasValue) {
                        isOpen = !isOpen
                    }
                }) {
                    Text("\(entry.name)\(entry.isRequired ? Text(" *").foregroundColor(.red) : Text(""))")
                    .foregroundColor(Colors.text)
                    .font(.custom(FontNameManager.PublicSans.regular, size: 18))
                }
                
                Spacer()
 
                if isOn && !(entry.isRequired && value == "") { Image(systemName: "checkmark")
                        .foregroundColor(.green)
                }

                    
                Text("\(entry.canRead ? "Read" : "")\(entry.canWrite ? "Write" : "")")
                    .padding(2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Colors.mainButtonColor, lineWidth: 2)
                    )
                    .font(.custom(FontNameManager.PublicSans.regular, size: 10))
            }
            if isOpen {
                Group {
                    TextField(entry.name, text: $value)
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
            Line()
                .stroke(style: StrokeStyle(lineWidth: 1))
                .frame(height: 1)
                .opacity(0.1)
        }
        .padding(.vertical, 5.0)
    }
}

struct Previews_ConsentEntry_Previews: PreviewProvider {
    static var previews: some View {
        ConsentEntry(consentEntry: ConsentEntryModel(name: "First Name",value: "", isRequired: true, canRead: true)
        )
    }
}
