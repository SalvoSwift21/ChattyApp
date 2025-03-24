//
//  LanguagesListView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 3/21/25.
//

import Foundation
import SwiftUI

public struct AIPreferenceHelpView: View {
    
    @Environment(\.dismiss) var dismiss
    var title: String
    var subtitle: String
    
    public init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
    
    public var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(LocalizedStringKey(title))
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 24))
                        .fontWeight(.semibold)
                        .foregroundStyle(.title)
                    
                    Text(LocalizedStringKey(subtitle))
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .foregroundStyle(.subtitle)
                    
                    Spacer()
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Text("GENERIC_CLOSE_ACTION")
                                .foregroundStyle(.prime)
                        }
                    }
                }
            }
        }
    }
}
