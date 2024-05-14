//
//  TagFilter.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 7.5.24..
//

import SwiftUI

struct TagFilter: View {
    var text: String
    @State private var isOpen: Bool = false
    @Binding var isTagsMenuActive: Bool
    @Binding var selectedTags: Set<OtherPartyTagUniffi>
    @Binding var tags: [OtherPartyTagUniffi]
    @Binding var filter: String?
    var showBadge = true
    let onCreateNew: ((String) -> Void)?
    
    var body: some View {
        
        Button(action: {
            withAnimation() {
                isOpen = !isOpen
            }
        }, label:{
            HStack(spacing: 0) {
                HStack(spacing: 0)  {
                    BasicText(text: text, size: 16)
                    if (showBadge) {
                        Badge(text: String(selectedTags.count))
                            .padding(.leading, 4)
                    }
                }
                
                Spacer()
                if isOpen {
                    Image("shrinkIcon")
                        .resizable()
                        .frame(width: 14, height: 7)
                } else {
                    Image("expandIcon")
                        .resizable()
                        .frame(width: 14, height: 7)
                }
            }
        })
        .onChange(of: isOpen) { newIsOpen in
            if (!newIsOpen) {
                withAnimation {
                    isTagsMenuActive = newIsOpen
                }
            }
        }
        
            if (isOpen) {
                DropDownMenu(options: tags, optionToString: {a in "#\(a.name)"}, selected: $selectedTags, filter: $filter, onCreateNew: onCreateNew)
                    .padding(.top, 8)
                HashtagView(tags: Array(selectedTags), optionToString: {a in a.name}, action: {id in
                    selectedTags = selectedTags.filter { tag in
                        tag.id != id
                    }
                })
                    
            }
            
    }
    
}
