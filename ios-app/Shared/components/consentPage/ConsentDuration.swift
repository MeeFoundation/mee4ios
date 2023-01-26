//
//  ConsentDuration.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 3.11.22..
//

import SwiftUI

struct ConsentDurationOption: Identifiable, Equatable {
    var id: String {
        return name
    }
    var name: String
    var description: String
    var value: ConsentStorageDuration
}

struct ConsentDuration: View {
    @Binding var consentEntries: [ConsentRequestClaim]
    var id: UUID
    var onComplete: () -> Void
    @State var storageDuration: ConsentStorageDuration = .whileUsingApp
    var entryType: ConsentEntryType = .string
    var entryName: String = ""
    var providedBy: String?
    
    init(consentEntries: Binding<[ConsentRequestClaim]>, id: UUID, onComplete: @escaping () -> Void) {
        self.id = id
        self.onComplete = onComplete
        self._consentEntries = consentEntries
        let consentEntryId = consentEntries.firstIndex{entry in
            entry.id == id
        }
        if let consentEntryId {
            self._storageDuration = State(initialValue: consentEntries[consentEntryId].retentionDuration.wrappedValue)
            self.entryType = consentEntries[consentEntryId].type.wrappedValue
            self.entryName = consentEntries[consentEntryId].name.wrappedValue
            self.providedBy = consentEntries[consentEntryId].providedBy.wrappedValue
        }
        
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    PopupButton(text: "Cancel") {
                        onComplete()
                    }
                    Spacer()
                    BasicText(text: "Metadata", size: 17, weight: .bold)
                    Spacer()
                    PopupButton(text: "Save") {
                        let consentEntryId = consentEntries.firstIndex{entry in
                            entry.id == id
                        }
                        if let consentEntryId {
                            consentEntries[consentEntryId].retentionDuration = storageDuration
                        }
                        onComplete()
                    }
                }
                .padding(.top, 17)
                .padding(.horizontal, 16)
                .padding(.bottom, 17)
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 0.5))
                    .frame(height: 1)
                    .foregroundColor(Colors.separatorLight.opacity(0.36))
                ZStack {
                    HStack {
                        VStack {
                            Image(getConsentEntryImageByType(entryType)).resizable().scaledToFit()
                                    .frame(width: 18, height: 18, alignment: .center)
                                    .padding(.trailing, 13)
                        }
                        
                        VStack {
                            BasicText(text: providedBy != nil && providedBy == "PRIVO" ? "Age" : entryName, size: 17, weight: .bold).frame(maxWidth: .infinity, alignment: .leading)
                            if entryName != "Private Personal Identifier" {
                                if let providedBy {
                                     BasicText(text: "Provided by \(providedBy)", size: 16, weight: .regular).frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 13)
                    .padding(.bottom, 10)
                    .background(.white)
                    .cornerRadius(14)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                BasicText(text: "STORAGE DURATION", color: Colors.labelLight.opacity(0.6), size: 12, weight: .regular).frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 24)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 16)
                ZStack {
                    VStack {
                        ForEach(consentDurationOptions, id: \.id) { durationElement in
                            ConsentDurationEntry(text: durationElement.name, description: durationElement.description, selected: durationElement.value == storageDuration) {
                                storageDuration = durationElement.value
                            }
                            if durationElement != consentDurationOptions.last {
                                Line()
                                    .stroke(style: StrokeStyle(lineWidth: 0.5))
                                    .frame(height: 1)
                                    .foregroundColor(Colors.separatorLight.opacity(0.36))
                            }
                            
                        }
                        
                    }
                    .padding(.horizontal, 16)
                    .background(.white)
                    .cornerRadius(14)
                }
                .padding(.horizontal, 16)
                
                
                
            }
            .padding(.bottom, 112)
            .background(Colors.gray200.opacity(0.93))
        }
    }
}

