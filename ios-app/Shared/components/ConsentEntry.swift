import SwiftUI
import Foundation

func getDateFormatter () -> DateFormatter {
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "YY/MM/dd"
    return dateFormatterPrint
}


struct ConsentEntry: View {
    @Binding var entry: ConsentRequestClaim
    var onDurationPopupShow: () -> Void
    var isReadOnly: Bool = false
    init(entry: Binding<ConsentRequestClaim>, isReadOnly: Bool?, onDurationPopupShow: @escaping () -> Void) {
        self._entry = entry
        self.onDurationPopupShow = onDurationPopupShow
        self.isReadOnly = isReadOnly ?? false
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
                        .blending(entry.isRequired || entry.isOn || (isReadOnly && entry.value != nil) ? Colors.meeBrand : Colors.gray600)
                        .frame(width: 18, height: 18, alignment: .center)
                        .padding(.trailing, 13)
                    
                }
                if ((entry.isRequired && entry.isOpen) || (!entry.isRequired && entry.isOn)) {
                    
                    ConsentSimpleEntryInput(value: $entry.value, name: entry.name, isRequired: entry.isRequired, type: entry.type, isIncorrect: entry.isIncorrect, isReadOnly: isReadOnly)
                    
                } else {
                    Button(action: {
                        entry.isOpen = !entry.isOpen
                    }) {
                        Text((!(entry.type == .boolean) && entry.value != nil) ? entry.value! : entry.name)
                            .foregroundColor(entry.isRequired || entry.isOn || (isReadOnly && entry.value != nil)  ? Colors.meeBrand : Colors.gray600)
                            .font(.custom(FontNameManager.PublicSans.regular, size: 18))
                    }
                }
                
                Spacer()
                if !entry.isRequired {
                    Checkbox(isToggled: isReadOnly ? Binding(get: {$entry.wrappedValue.value != nil}, set: {_ in }) : $entry.isOn)
                        .disabled(isReadOnly)
                } else if !isReadOnly {
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

