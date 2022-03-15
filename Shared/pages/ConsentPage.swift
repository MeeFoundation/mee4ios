//
//  ConsentPage.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 16.02.2022.
//

import SwiftUI

struct ConsentPage: View {
    @StateObject var data = ConsentState()
    var body: some View {
        ZStack {
            Background()
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
                Text(data.consent.name)
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
                    ForEach(data.consent.entries) { entry in
                        ConsentEntry(consentEntry: entry)
                    }
                    .padding(.bottom, 20.0)
                    .padding(.trailing, 10.0)
                }
                HStack {
                    Text("Scopes: ")
                        .foregroundColor(Colors.text)
                        .font(.custom(FontNameManager.PublicSans.bold, size: 18))
                    Text("\(data.consent.scopes.joined(separator: ", "))")
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
                    HStack {
                    Button(action: {}){
                        Link("APPROVE", destination: URL(string: "http://localhost:3000/?interest=sweets")!)
                    }
                    .buttonStyle(MainButtonStyle())
                    Spacer()
                    DestructiveButton("DECLINE", action: {})
                }
                .padding(.top, 10.0)
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
