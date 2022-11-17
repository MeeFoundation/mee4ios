//
//  ConsentDurationEntry.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

import SwiftUI

struct ConsentDurationEntry: View {
    var text: String
    var description: String
    var selected: Bool
    var onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            HStack {
                VStack {
                    BasicText(text: text, size: 17).frame(maxWidth: .infinity, alignment: .leading)
                    BasicText(text: description, size: 12, textAlignment: TextAlignment.leading).frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                if selected {
                    Image("blueCheckmark").resizable().scaledToFit().frame(width: 15)
                    
                }
            }
            
        }
        .padding(.vertical, 8)
        
    }
}
