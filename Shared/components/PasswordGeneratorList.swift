//
//  PasswordGeneratorList.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 04.04.2022.
//

import Foundation
import SwiftUI

struct PasswordGeneratorList: View {
    @Binding var keywords: [KeywordEntry]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        Group {
            VStack {
                HStack {
                    Spacer()
                    Button("+ Add keyword") {
                        keywords.append(KeywordEntry(value: ""))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                
                List {
                    ForEach($keywords) { ($keyword) in
                        HStack {
                            TextField("Keyword", text: optionalBinding(binding: $keyword.value))
                        }
                        
                    }
                    .onDelete(perform: { indexSet in self.keywords.remove(atOffsets: indexSet)})
                }
                
            }
            
            VStack {
                MainButton("Close", action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, image: Image(systemName: "xmark.circle"), fullWidth: true)
//                DestructiveButton("Cancel", action: {
//                    self.presentationMode.wrappedValue.dismiss()
//                })
            }
            .padding(.horizontal, 50)
        }
        .background(Colors.background)
    }
}
