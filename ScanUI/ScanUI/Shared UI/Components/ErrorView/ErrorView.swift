//
//  SwiftUIView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 05/12/23.
//

import SwiftUI

struct ErrorView: View {
    
    let title: String
    let description: String
    
    let primaryButtonTitle: String
    let primaryAction: () -> Void

    let secondaryButtonTitle: String?
    let secondaryAction: (() -> Void)?

    var body: some View {
        VStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.red)
            Text(description)
                .font(.subheadline)
                .fontWeight(.regular)
                .foregroundStyle(.subtitle)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
            HStack() {
                Button(action: { primaryAction() }) {
                    Text(primaryButtonTitle)
                        .font(.footnote)
                        .fontWeight(.bold)
                }.buttonStyle(DefaultButtonStyle(frame: .init(width: 100, height: 30)))
                
                if let secondaryAction = self.secondaryAction, let secondaryButtonTitle = self.secondaryButtonTitle {
                    Button(action: { secondaryAction() }) {
                        Text(secondaryButtonTitle)
                            .font(.footnote)
                            .fontWeight(.bold)
                    }.buttonStyle(DefaultButtonStyle(frame: .init(width: 100, height: 30), backgroundColor: .red))
                }
            }
        }
        .padding()
        .background(.white)
        .clipShape(.buttonBorder)
        .shadow(radius: 10.0)
    }
}

#Preview {
    VStack {
        ErrorView(title: "Test errore", description: "Test test descrizione", primaryButtonTitle: "Ok", primaryAction: { print("First") }, secondaryButtonTitle: "non ok", secondaryAction: { print("Second") })
        
        ErrorView(title: "Test errore", description: "Test test descrizione", primaryButtonTitle: "Ok", primaryAction: { print("First") }, secondaryButtonTitle: nil, secondaryAction: nil)
    }
}
