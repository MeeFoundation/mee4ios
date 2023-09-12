import SwiftUI
import Combine

struct ConsentAgeProtectEntryInput: View {
    @Binding var value: AgeProtectCardEntry
    var isIncorrect: Bool
    var name: String
    var isRequired: Bool
    var type: ConsentEntryType
    var isReadOnly: Bool
    
    init(value: Binding<AgeProtectCardEntry>, name: String, isRequired: Bool, type: ConsentEntryType, isIncorrect: Bool, isReadOnly: Bool) {
        print("ConsentAgeProtectEntryInput")
        self._value = value
        self.name = name
        self.isRequired = isRequired
        self.type = type
        self.isIncorrect = isIncorrect
        self.isReadOnly = isReadOnly
    }
    @State private var calendarVisible = false
    @State private var date: Date = Date()
    
    
    
    var body: some View {
        Group {
            VStack {
                
                VStack(spacing: 0) {
                    TextField("Issuer", text:  optionalBinding(binding: Binding(get: {
                        return "Issuer: Privo"
                    }, set: {newValue in })))
                    .autocorrectionDisabled(true)
                    TextField("BirthDate", text:  optionalBinding(binding: $value.dateOfBirth))
                    .autocorrectionDisabled(true)
                    TextField("Age", text:  optionalBinding(binding: $value.age))
                    .autocorrectionDisabled(true)
                    TextField("Jurisdiction", text:  optionalBinding(binding: $value.jurisdiction))
                    .autocorrectionDisabled(true)
                }
                
            }
            .disabled(isReadOnly)
            .preferredColorScheme(.light)
            .foregroundColor(Colors.text)
            .multilineTextAlignment(.leading)
            .padding(EdgeInsets(top: 11, leading: 16, bottom: 11, trailing: 16))
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1.0)
                    .fill(isIncorrect ? Colors.error : Colors.gray)
            )
        }
        .padding(.horizontal, 1)
        .padding(.top, 4.0)
    }
}
