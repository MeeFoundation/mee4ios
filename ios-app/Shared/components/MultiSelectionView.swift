//
//  MultiSelectionView.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 7.5.24..
//

import SwiftUI

struct DropDownMenu<Selectable: Identifiable & Hashable>: View  {
    let options: [Selectable]
    let optionToString: (Selectable) -> String

    var buttonHeight: CGFloat = 46
    var maxItemDisplayed: Int = 5

    @Binding var selected: Set<Selectable>
    @Binding var filter: String?
    
    @State var showDropdown: Bool = false
    
    @State private var scrollViewSize: CGSize = .zero
    
    @State private var filteredOptions: [Selectable] = []
    
    let onCreateNew: ((String) -> Void)?
    
    func getFilteredOptions(_ options: [Selectable]) -> [Selectable] {
        return options.filter { i in
            if let filter {
                if filter != "" {
                    return optionToString(i).contains(filter)
                }
            }
            return true
        }
    }
    
    private func toggleSelection(selectable: Selectable) {
        if let existingIndex = selected.firstIndex(where: { $0.id == selectable.id }) {
            selected.remove(at: existingIndex)
        } else {
            selected.insert(selectable)
        }
    }
    
    var optionsCount: Int {
        return onCreateNew != nil && filter != nil && filter != "" ? options.count + 1 : options.count
    }

    var body: some View {
        VStack(spacing: 0) {

            VStack(spacing: 0) {
                TagInput(isActive: $showDropdown, text: $filter)
                    .padding(.bottom, 2)

                
                // selection menu
                if (showDropdown) {
                    let scrollViewHeight: CGFloat = optionsCount > maxItemDisplayed ? (buttonHeight*CGFloat(maxItemDisplayed)) : (buttonHeight*CGFloat(optionsCount))
                    ScrollView {
                        VStack(spacing: 0) {
                            if (onCreateNew != nil && filter != nil && filter != "" && options.first { o in
                                if let filter {
                                    let itemName = optionToString(o).dropFirst()
                                    return itemName == filter
                                }
                                return false
                            } == nil ) {
                                HStack(spacing: 0) {
                                    BasicText(text: "#\(filter ?? "")", size: 17)
                                        .foregroundColor(.black)
                                        .padding(.vertical, 12)
                                    
                                    Spacer()
                                    BasicText(text: "Create", color: Colors.mainButtonTextColor, size: 12)
                                }
                                .padding(.horizontal, 16)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if let filter, let onCreateNew {
                                        onCreateNew(filter)
                                    }
                                }
                                Line()
                                    .stroke(style: StrokeStyle(lineWidth: 1))
                                    .frame(height: 1)
                                    .foregroundColor(Colors.separatorLight.opacity(0.36))
                            }
                            ForEach(filteredOptions) { selectable in
                                
                                HStack(spacing: 0) {
                                    BasicText(text: optionToString(selectable), size: 17)
                                        .foregroundColor(.black)
                                        .padding(.vertical, 12)
                                    
                                    Spacer()
                                    
                                    if selected.contains(where: { $0.id == selectable.id }) {
                                        Image("listCheckmark")
                                    }
                                }
                                .padding(.horizontal, 16)
                                .background(selected.contains(where: { $0.id == selectable.id }) ? Colors.gray100 : Color.white)
                                .tag(selectable.id)
                                .onTapGesture {
                                    toggleSelection(selectable: selectable)
                                }
                                if (selectable != filteredOptions.last) {
                                    Line()
                                        .stroke(style: StrokeStyle(lineWidth: 1))
                                        .frame(height: 1)
                                        .foregroundColor(Colors.separatorLight.opacity(0.36))
                                }
                            }
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Colors.labelLight.opacity(0.36), lineWidth: 1)
                    )
                    .background(.white)
//                    .scrollPosition(id: $scrollPosition)
//                    .scrollDisabled(options.count <= 3)
                    .frame(height: scrollViewHeight)
 
                
                }
                
            }
            
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: buttonHeight, alignment: .top)
        .zIndex(100)
        .onAppear {
            filteredOptions = getFilteredOptions(options)
        }
        .onChange(of: options) { newOptions in
            filteredOptions = getFilteredOptions(newOptions)
        }
        .onChange(of: filter) { _ in
            filteredOptions = getFilteredOptions(options)
        }
        
    }
}
