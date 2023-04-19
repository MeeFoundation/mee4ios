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
    
    var body: some View {
        VStack{
            HStack {
                Button(action: {
                    entry.isOpen = !entry.isOpen
                }) {
                    Image(getConsentEntryImageByType(entry.type))
                        .resizable()
                        .scaledToFit()
                        .blending(entry.isRequired || entry.isOn || (isReadOnly && entry.value != nil) ? Colors.meeBrand : Colors.gray600)
                        .frame(width: 18, height: 18, alignment: .center)
                        .padding(.trailing, 13)
                    
                }
                if ((entry.isRequired && entry.isOpen) || (!entry.isRequired && entry.isOn)) {
                    if case .string(let string) = entry.value {
                        ConsentSimpleEntryInput(value: Binding(get: {string}, set: { entry.value = .string($0)}), name: entry.name, isRequired: entry.isRequired, type: entry.type, isIncorrect: entry.isIncorrect, isReadOnly: isReadOnly)
                    } else if case .card(let card) = entry.value {
                        ConsentCardEntryInput(value: Binding(get: {card}, set: { entry.value = .card($0)}), name: entry.name, isRequired: entry.isRequired, type: entry.type, isIncorrect: entry.isIncorrect, isReadOnly: isReadOnly)
                    }
                    
                    
                } else {
                    Button(action: {
                        entry.isOpen = !entry.isOpen
                    }) {
                        Text(entry.getFieldName())
                            .foregroundColor(entry.isRequired || entry.isOn || (isReadOnly && entry.value != nil)  ? Colors.meeBrand : Colors.gray600)
                            .font(.custom(FontNameManager.PublicSans.regular, size: 18))
                    }
                }
                
                Spacer()
                if !entry.isRequired {
                    Checkbox(isToggled: isReadOnly ? Binding(get: {
                        switch $entry.wrappedValue.value {
                        case .string(let string):
                            return string != nil && string != ""
                        case .card(let card):
                            return card.number != nil && card.expirationDate != nil && card.cvc != nil
                        
                        default: return $entry.wrappedValue.value != nil
                        }
                        
                        
                    }, set: {_ in }) : $entry.isOn)
                        .disabled(isReadOnly)
                        .opacity(isReadOnly ? 0 : 1)
                } else if !isReadOnly {
                    Button(action: {
                        onDurationPopupShow()
                    }) {
                        Image("arrowRight").resizable().scaledToFit().frame(width: 7)
                    }
                    
                }
                
            }
            
        }
    }
}
