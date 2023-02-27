//
//  ConsentDetails.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct PartnerDetails: View {
    let request: ConsentRequest
    @State var state = PartnerDetailsState()
    init(request: ConsentRequest) {
        print("request: ", request)
        self.request = request
    }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let agent = MeeAgentStore()
    
    
    func removeConsent() {
        agent.removeItembyName(id: request.id)
        self.presentationMode.wrappedValue.dismiss()
        
    }
    
    var body: some View {
        return (
            
            VStack {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        
                    }) {
                        HStack {
                            Image(systemName: "chevron.backward")
                            
                            Text("Back")
                                .foregroundColor(Colors.text)
                                .font(.custom(FontNameManager.PublicSans.regular , size: 18))
                        }
                        .padding(.leading, 9)
                    }
                    Spacer()
                    BasicText(text: "Manage Connection", color: .black ,size: 17, fontName: FontNameManager.PublicSans.semibold)
                        .padding(.trailing, 69)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 59)
                .padding(.bottom, 10)
                .background(Colors.backgroundAlt1)
                .shadow(color: Color.black.opacity(0.3), radius: 0, x: 0, y: 0.5)
                ScrollView {
                    PartnerEntry(request: request, hasEntry: false)
                        .border(Colors.meeBrand, width: 2)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 48)
                        .padding(.top, 16)
                    Expander(title: "Required info shared", isOpen: $state.isRequiredOpen) {
                        ForEach($state.consentEntries.filter {$0.wrappedValue.isRequired}) { $entry in
                            VStack {
                                ConsentEntry(entry: $entry, isReadOnly: true) {
                                    state.durationPopupId = entry.id
                                }
                                .id(entry.id)
                                Divider()
                                    .frame(height: 1)
                                    .background(Colors.gray)
                            }
                            
                            
                        }
                        .padding(.top, 19)
                        .padding(.leading, 3)
                        
                    }
                    .padding(.horizontal, 16)
                    if $state.consentEntries.firstIndex {!$0.wrappedValue.isRequired} != nil {
                        Expander(title: "Optional info shared", isOpen: $state.isOptionalOpen) {
                            ForEach($state.consentEntries.filter {!$0.wrappedValue.isRequired}) { $entry in
                                VStack {
                                    ConsentEntry(entry: $entry, isReadOnly: true) {
                                        state.durationPopupId = entry.id
                                    }
                                    .id(entry.id)
                                    Divider()
                                        .frame(height: 1)
                                        .background(Colors.gray)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                    Spacer()
                    
//                    Button(action: {
//
//                    }){
//                        HStack(spacing: 0) {
//                            BasicText(text: "Block Connection", color: Color.black, size: 17)
//                            Spacer()
//                            Image("blockIcon").resizable().scaledToFit().frame(height: 17)
//                        }
//                        .padding(.vertical, 12)
//                        .padding(.leading, 16)
//                        .padding(.trailing, 19)
//                        .background(.white)
//                    }
//                    .cornerRadius(12)
//                    .shadow(color: Color.black.opacity(0.1), radius: 64, x: 0, y: 8)
//                    .padding(.bottom, 16)
//                    .padding(.top, 80)
//                    .padding(.horizontal, 16)
                    
                    
                    Button(action: removeConsent){
                        HStack(spacing: 0) {
                            BasicText(text: "Delete Connection", color: Colors.error, size: 17)
                            Spacer()
                            Image("trashIcon").resizable().scaledToFit().frame(height: 17)
                        }
                        .padding(.vertical, 12)
                        .padding(.leading, 16)
                        .padding(.trailing, 19)
                        .background(.white)
                    }
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 64, x: 0, y: 8)
                    .padding(.top, 80)
                    .padding(.bottom, 16)
                    .padding(.horizontal, 16)
                }
                
                
            }
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                .onAppear{
                    if let consentData = agent.getItemById(id: request.id) {
                        state.consentEntries = consentData.claims
                    }
                    
                }
                .overlay {
                    PopupWrapper(isVisible: state.durationPopupId != nil) {
                        if let durationPopupId = state.durationPopupId {
                            ConsentDuration(consentEntries: $state.consentEntries, id: durationPopupId){
                                state.durationPopupId = nil
                            }
                        }

                    }
                }
        )
    }
}
