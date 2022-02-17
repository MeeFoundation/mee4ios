//
//  ConsentPage.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 16.02.2022.
//

import SwiftUI

struct ConsentPage: View {
    @State var data = ConsentModel(name: "Eat Naked Kitchen",entries: [ConsentEntryModel(name: "First Name",value: "", isRequired: true, canRead: true),
        ConsentEntryModel(name: "Email", value: "", isRequired: true, canRead: true),
        ConsentEntryModel(name: "Date Of Birth", value: "", canRead: true),
        ConsentEntryModel(name: "Mee Orders", value: "", canRead: true, canWrite: true, hasValue: false)], scopes: ["OpenId", "Email", "First Name"])
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Colors.background)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Image("meeLogo").resizable().scaledToFit()
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .frame(height: 1)
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 30))
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .frame(height: 1)
                    Text("ENK")
                        .foregroundColor(Colors.text)
                        .font(.custom(FontNameManager.PublicSans.bold, size: 31))
                    
                }
                .padding(.bottom, 10.0)
                Text(data.name)
                    .foregroundColor(Colors.text)
                    .font(.custom(FontNameManager.PublicSans.bold, size: 25))
                    .padding(.bottom, 5.0)
                Text("Needs access to following information:")
                    .foregroundColor(Colors.text)
                    .font(.custom(FontNameManager.PublicSans.regular, size: 18))
                    .padding(.bottom, 35.0)
//                Button(action: buttonAction, label: {
//                    Text("Tap Here")
//                })
                Spacer()
                ScrollView {
                    ForEach(data.entries) { entry in
                        ConsentEntry(consentEntry: entry)
                    }
                    .padding(.bottom, 20.0)
                    .padding(.trailing, 10.0)
                }
                HStack {
                    Text("Scopes: ")
                        .foregroundColor(Colors.text)
                        .font(.custom(FontNameManager.PublicSans.bold, size: 18))
                    Text("\(data.scopes.joined(separator: ", "))")
                        .foregroundColor(Colors.text)
                        .font(.custom(FontNameManager.PublicSans.regular, size: 18))
                    Spacer()
                }
                .padding(.bottom, 10.0)
                HStack {
                    Text("*")
                        .foregroundColor(.red)
                        .font(.custom(FontNameManager.PublicSans.bold, size: 18))
                    Text("- required attribute")
                        .foregroundColor(Colors.text)
                        .font(.custom(FontNameManager.PublicSans.regular, size: 18))
                    Spacer()
                }

                Spacer()
                Button(action: {}){
                    Link("APPROVE", destination: URL(string: "http://localhost:3001/?interest=sweets")!)
                }
                .padding()
                .foregroundColor(Colors.mainButtonColor)
                Button(action: {}){
                    Text("DECLINE")
                }
                .padding()
                .foregroundColor(.red)
            }
            .padding(.horizontal, 10.0)
            
        }
        
    }
    func buttonAction(){

    }
        
    
}

struct Previews_ConsentPage_Previews: PreviewProvider {
    static var previews: some View {
        ConsentPage()
    }
}
