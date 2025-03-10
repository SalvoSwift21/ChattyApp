//
//  SwiftUIView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 05/12/23.
//

import SwiftUI

struct ErrorView: View {
    
    let title: LocalizedStringKey
    let description: LocalizedStringKey
    
    let primaryButtonTitle: LocalizedStringKey
    let primaryAction: () -> Void

    let secondaryButtonTitle: LocalizedStringKey?
    let secondaryAction: (() -> Void)?

    init(title: String, description: String, primaryButtonTitle: String, primaryAction: @escaping () -> Void, secondaryButtonTitle: String?, secondaryAction: (() -> Void)?) {
        self.title = LocalizedStringKey(title)
        self.description = LocalizedStringKey(description)
        self.primaryButtonTitle = LocalizedStringKey(primaryButtonTitle)
        self.primaryAction = primaryAction
        if let secondaryButtonTitle {
            self.secondaryButtonTitle = LocalizedStringKey(secondaryButtonTitle)
            self.secondaryAction = secondaryAction
        } else {
            self.secondaryAction = nil
            self.secondaryButtonTitle = nil
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 20.0) {
                VStack(spacing: 10) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                    Text(description)
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundStyle(.subtitle)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 5)
                }
                
                VStack(spacing: 10) {
                    Button(action: { primaryAction() }) {
                        Text(primaryButtonTitle)
                            .font(.body)
                            .fontWeight(.semibold)
                    }.buttonStyle(DefaultButtonStyle(frame: .init(width: 200, height: 45)))
                    
                    if let secondaryAction = self.secondaryAction, let secondaryButtonTitle = self.secondaryButtonTitle {
                        Button(action: { secondaryAction() }) {
                            Text(secondaryButtonTitle)
                                .font(.body)
                                .fontWeight(.semibold)
                        }.buttonStyle(DefaultButtonStyle(frame: .init(width: 200, height: 45), backgroundColor: .red))
                    }
                }.padding()
            }
            .padding()
            .background(.white)
            .clipShape(.rect(cornerRadius: 10.0))
            .shadow(radius: 10.0)
        }
        .padding()
    }
}

#Preview {
    VStack {
        ErrorView(title: "Test errore", description: "Test test descrizione", primaryButtonTitle: "Ok", primaryAction: { print("First") }, secondaryButtonTitle: "non ok", secondaryAction: { print("Second") })
        
        ErrorView(title: "Test errore", description: "Test test descrizione", primaryButtonTitle: "Ok", primaryAction: { print("First") }, secondaryButtonTitle: nil, secondaryAction: nil)
    }
}
