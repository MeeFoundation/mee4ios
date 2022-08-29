//
//  ConsentEntry.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.02.2022.
//

import SwiftUI
import Foundation

func getDateFormatter () -> DateFormatter {
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "YY/MM/dd"
    return dateFormatterPrint
}


struct ConsentEntryInput: View {
    @Binding var value: String?
    var name: String
    var readOnly: Bool
    var isRequired: Bool
    var type: ConsentEntryType
    
    init(value: Binding<String?>, name: String, readOnly: Bool, isRequired: Bool, type: ConsentEntryType) {
        self._value = value
        self.name = name
        self.readOnly = readOnly
        self.isRequired = isRequired
        self.type = type
    }
    @State private var calendarVisible = false
    @State private var date: Date = Date()
    
    var body: some View {
        Group {
            TextField(name, text:  optionalBinding(binding: $value))
                .fixedSize(horizontal: false, vertical: true).disabled(readOnly)
                .multilineTextAlignment(.leading)
                .padding(EdgeInsets(top: 11, leading: 16, bottom: 11, trailing: 16))
                .cornerRadius(5)
                .autocapitalization(type == .email ? .none : .sentences)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1.0)
                        .fill((isRequired && (value == nil || value!.isEmpty)) ? Colors.error : Colors.grey)
                )
                .onChange(of: date, perform: { value in
                    //calendarVisible = false
                    print(value)
                })
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
                    //.frame(width: 320, height: 400)
                }
        }
        .padding(.horizontal, 1)
        .padding(.top, 4.0)
    }
}

struct ConsentEntry: View {
    var entry: Binding<ConsentEntryModel>
    @State var isOn = true
    @State var isOpen: Bool
    init(entry: Binding<ConsentEntryModel>) {
        self.entry = entry
        _isOpen = State(initialValue: entry.wrappedValue.isRequired && (entry.wrappedValue.value?.isEmpty ?? true))
    }
    
    var body: some View {
        VStack{
            HStack {
                Button(action: {
                    if (!isOpen || !(entry.wrappedValue.value?.isEmpty ?? true)) {
                        isOpen = !isOpen
                    }
                }) { Image(getConsentEntryImageByType(entry.wrappedValue.type)).resizable().scaledToFit()
                        .frame(width: 18, height: 18, alignment: .center)
                        .padding(.trailing, 13)
                }
                if (isOpen && entry.wrappedValue.isRequired) {
                    ConsentEntryInput(value: entry.value, name: entry.wrappedValue.name, readOnly: !entry.wrappedValue.canWrite, isRequired: entry.wrappedValue.isRequired, type: entry.wrappedValue.type)
                } else {
                    Button(action: {
                        if (entry.wrappedValue.hasValue) {
                            isOpen = !isOpen
                        }
                    }) {
                        Text(entry.wrappedValue.name)
                            .foregroundColor(Colors.meeBrand)
                            .font(.custom(FontNameManager.PublicSans.regular, size: 18))
                    }
                }
                
                Spacer()
                if !entry.wrappedValue.isRequired {
                    Checkbox(isToggled: $isOn)
                }
                
            }
            if (isOpen && !entry.wrappedValue.isRequired) {
                ConsentEntryInput(value: entry.value, name: entry.wrappedValue.name, readOnly: !entry.wrappedValue.canWrite, isRequired: entry.wrappedValue.isRequired, type: entry.wrappedValue.type)
            }
        }
    }
}

//struct Previews_ConsentEntry_Previews: PreviewProvider {
//    static var previews: some View {
//        ConsentEntry(consentEntry: ConsentEntryModel(name: "First Name", isRequired: true, canRead: true)
//        )
//    }
//}
