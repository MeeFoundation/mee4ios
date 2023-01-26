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
    var isRequired: Bool
    var type: ConsentEntryType
    
    init(value: Binding<String?>, name: String, isRequired: Bool, type: ConsentEntryType, isIncorrect: Bool) {
        self._value = value
        self.name = name
        self.isRequired = isRequired
        self.type = type
        self.isIncorrect = isIncorrect
    }
    @State private var calendarVisible = false
    @State private var date: Date = Date()
    
    var body: some View {
        Group {
            TextField(name, text:  optionalBinding(binding: $value))
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
    }
}

struct ConsentEntry: View {
    @Binding var entry: ConsentRequestClaim
    var onDurationPopupShow: () -> Void
    init(entry: Binding<ConsentRequestClaim>, onDurationPopupShow: @escaping () -> Void) {
        self._entry = entry
        self.onDurationPopupShow = onDurationPopupShow
    }
    
    
    func validateEntry() {
//        entry.isIncorrect = false
//
//        if ((entry.isRequired || isOn) && (entry.value == nil || entry.value!.isEmpty)) {
//            entry.isIncorrect = true
//        }
    }
    
    var body: some View {
        VStack{
            HStack {
                Button(action: {
                    if (!entry.isOpen || !(entry.value?.isEmpty ?? true)) {
                        entry.isOpen = !entry.isOpen
                    }
                }) {
                    Image(getConsentEntryImageByType(entry.type))
                        .resizable()
                        .scaledToFit()
                        .blending(entry.isRequired || entry.isOn ? Colors.meeBrand : Colors.gray600)
                        .frame(width: 18, height: 18, alignment: .center)
                        .padding(.trailing, 13)
                        
                }
                if ((entry.isRequired && entry.isOpen) || (!entry.isRequired && entry.isOn)) {
                    ConsentEntryInput(value: $entry.value, name: entry.name, isRequired: entry.isRequired, type: entry.type, isIncorrect: entry.isIncorrect)
                } else {
                    Button(action: {
                        entry.isOpen = !entry.isOpen
                    }) {
                        Text((!(entry.type == ConsentEntryType.boolean) && entry.value != nil) ? entry.value! : entry.name)
                            .foregroundColor(entry.isRequired || entry.isOn ? Colors.meeBrand : Colors.gray600)
                            .font(.custom(FontNameManager.PublicSans.regular, size: 18))
                    }
                }
                
                Spacer()
                if !entry.isRequired {
                    Checkbox(isToggled: $entry.isOn)
                } else {
                    Button(action: {
                        onDurationPopupShow()
                    }) {
                        Image("arrowRight").resizable().scaledToFit().frame(width: 7)
                    }
                    
                }
                
            }
//            if (entry.isOpen && !entry.isRequired) {
//                ConsentEntryInput(value: $entry.value, name: entry.name, readOnly: !entry.canWrite, isRequired: entry.isRequired, type: entry.type, isIncorrect: entry.isIncorrect)
//            }
        }
        .onChange(of: entry.value, perform: { _ in
            entry.isOpen = true
            validateEntry()
            
        })
        .onChange(of: entry.isOn, perform: { _ in validateEntry() })
        .onAppear(perform: { validateEntry() })
    }
}

