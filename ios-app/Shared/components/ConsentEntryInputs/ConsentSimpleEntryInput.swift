//
//  ConsentStringEntryInput.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 23.3.23..
//

import SwiftUI

struct ConsentSimpleEntryInput: View {
    @Binding var value: String?
    var isIncorrect: Bool
    var name: String
    var isRequired: Bool
    var type: ConsentEntryType
    var isReadOnly: Bool
    let id: UUID
    @Binding var scrollPosition: UUID?
    @FocusState var inFocus: UUID?
    
    init(value: Binding<String?>, name: String, isRequired: Bool, type: ConsentEntryType, isIncorrect: Bool, isReadOnly: Bool, id: UUID, scrollPosition: Binding<UUID?>) {
        self._value = value
        self.name = name
        self.isRequired = isRequired
        self.type = type
        self.isIncorrect = isIncorrect
        self.isReadOnly = isReadOnly
        self._scrollPosition = scrollPosition
        self.id = id
    }
    @State private var calendarVisible = false
    @State private var date: Date = Date()
    
    var body: some View {
        Group {
            TextField(name, text:  optionalBinding(binding: $value),onEditingChanged: { (started) in
                if started {
                    scrollPosition = id
                    scrollPosition = id
                    
                }
            })
            .focused($inFocus, equals: id)
                .disabled(isReadOnly)
                .preferredColorScheme(.light)
                .foregroundColor(Colors.text)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .padding(EdgeInsets(top: 11, leading: 16, bottom: 11, trailing: 16))
                .cornerRadius(5)
                .autocapitalization(type == .email ? .none : .sentences)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1.0)
                        .fill(isIncorrect ? Colors.error : Colors.gray)
                )
                .if(type == .date) { $0.overlay( Button(action: {
                    calendarVisible = true
                }) {
                    Image("calendarIcon")
                        .resizable()
                        .frame(width: 18, height: 18, alignment: .center)
                        .padding(.vertical, 13)
                        .padding(.trailing, 19)
                }
                                                 ,
                                                 alignment: Alignment.topTrailing)}
                .popover(isPresented: $calendarVisible) {
                    NavigationView {
                        VStack {
                            DatePicker("Date", selection: $date, displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()
                            
                            Spacer()
                        }
                        .navigationBarTitle(Text("Select Date"), displayMode: .inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Done") {
                                    value = getDateFormatter().string(from: date)
                                    calendarVisible = false
                                }
                            }
                        }
                    }
                    .accentColor(.red)
                }
        }
        .padding(.horizontal, 1)
        .padding(.top, 4.0)
        .focused($inFocus, equals: id)
        .id(id)
    }
}
