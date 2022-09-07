import SwiftUI
import Foundation

func getDateFormatter () -> DateFormatter {
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "YY/MM/dd"
    return dateFormatterPrint
}


struct ConsentEntryInput: View {
    @Binding var value: String?
    var isIncorrect: Bool
    var name: String
    var readOnly: Bool
    var isRequired: Bool
    var type: ConsentEntryType
    
    init(value: Binding<String?>, name: String, readOnly: Bool, isRequired: Bool, type: ConsentEntryType, isIncorrect: Bool) {
        self._value = value
        self.name = name
        self.readOnly = readOnly
        self.isRequired = isRequired
        self.type = type
        self.isIncorrect = isIncorrect
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
                        .fill(isIncorrect ? Colors.error : Colors.grey)
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
    }
}

struct ConsentEntry: View {
    @Binding var entry: ConsentEntryModel
    @State var isOn = true
    @State var isOpen: Bool
    init(entry: Binding<ConsentEntryModel>) {
        self._entry = entry
        _isOpen = State(initialValue: entry.wrappedValue.isRequired && (entry.wrappedValue.value?.isEmpty ?? true))
    }
    
    func validateEntry() {
        entry.isIncorrect = false

        if ((entry.isRequired || isOn) && (entry.value == nil || entry.value!.isEmpty)) {
            entry.isIncorrect = true
        }
    }
    
    var body: some View {
        VStack{
            HStack {
                Button(action: {
                    if (!isOpen || !(entry.value?.isEmpty ?? true)) {
                        isOpen = !isOpen
                    }
                }) { Image(getConsentEntryImageByType(entry.type)).resizable().scaledToFit()
                        .frame(width: 18, height: 18, alignment: .center)
                        .padding(.trailing, 13)
                }
                if (isOpen && entry.isRequired) {
                    ConsentEntryInput(value: $entry.value, name: entry.name, readOnly: !entry.canWrite, isRequired: entry.isRequired, type: entry.type, isIncorrect: entry.isIncorrect)
                } else {
                    Button(action: {
                        if (entry.hasValue) {
                            isOpen = !isOpen
                        }
                    }) {
                        Text(entry.name)
                            .foregroundColor(Colors.meeBrand)
                            .font(.custom(FontNameManager.PublicSans.regular, size: 18))
                    }
                }
                
                Spacer()
                if !entry.isRequired {
                    Checkbox(isToggled: $isOn)
                }
                
            }
            if (isOpen && !entry.isRequired) {
                ConsentEntryInput(value: $entry.value, name: entry.name, readOnly: !entry.canWrite, isRequired: entry.isRequired, type: entry.type, isIncorrect: entry.isIncorrect)
            }
        }
        .onChange(of: entry.value, perform: { _ in validateEntry() })
        .onChange(of: isOn, perform: { _ in validateEntry() })
        .onAppear(perform: { validateEntry() })
    }
}

