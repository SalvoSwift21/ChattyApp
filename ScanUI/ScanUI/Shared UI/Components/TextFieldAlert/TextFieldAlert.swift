//
//  CustomAlert.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 14/05/24.
//

import SwiftUI

struct TextFieldAlert: ViewModifier {
    @Binding var text: String
    var title: String
    var okButtonTitle: String
    var message: String?
    var placeholder: String
    var action: () -> Void

    @Binding var isShowingAlert: Bool

    func body(content: Content) -> some View {
        content.alert(title, isPresented: $isShowingAlert) {
            TextField(placeholder, text: $text)
            Button(okButtonTitle, action: action)
            Button("cancel", action: { self.isShowingAlert.toggle() })
        } message: {
            if let message = message {
                Text(message)
            }
        }
    }
}

extension View {
    func textFieldAlert(text: Binding<String>, title: String, okButtonTitle: String, message: String? = nil, placeholder: String, isShowingAlert: Binding<Bool>, action: @escaping () -> Void) -> some View {
        self.modifier(TextFieldAlert(text: text, title: title, okButtonTitle: okButtonTitle, message: message, placeholder: placeholder, action: action, isShowingAlert: isShowingAlert))
    }
}
