//
//  CustomAlert.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 14/05/24.
//

import SwiftUI

struct TextFieldAlert: ViewModifier {
       
    @Binding var text: String
    var title: LocalizedStringKey
    var okButtonTitle: LocalizedStringKey
    var message: LocalizedStringKey?
    var placeholder: LocalizedStringKey
    var action: () -> Void

    @Binding var isShowingAlert: Bool

    func body(content: Content) -> some View {
        content.alert(title, isPresented: $isShowingAlert) {
            TextField(placeholder, text: $text)
            Button(okButtonTitle, action: action)
            Button(String(localized: "GENERIC_CANCEL_TITLE"), action: { self.isShowingAlert.toggle() })
        } message: {
            if let message = message {
                Text(message)
            }
        }
    }
}

extension View {
    func textFieldAlert(text: Binding<String>, title: String, okButtonTitle: String, message: String = "", placeholder: String, isShowingAlert: Binding<Bool>, action: @escaping () -> Void) -> some View {
        return self.modifier(TextFieldAlert(text: text, title: LocalizedStringKey(title), okButtonTitle: LocalizedStringKey(okButtonTitle), message: message.isEmpty ? nil : LocalizedStringKey(message), placeholder: LocalizedStringKey(placeholder), action: action, isShowingAlert: isShowingAlert))
    }
}
