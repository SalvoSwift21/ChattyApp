//
//  EmptyStateView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 3/16/25.
//

import SwiftUI

public struct EmptyStateView: View {
    
    var iconSystemName: String = "doc.text.viewfinder"
    var title: String
    var subtitle: String
    
    public init(iconSystemName: String, title: String, subtitle: String) {
        self.iconSystemName = iconSystemName
        self.title = title
        self.subtitle = subtitle
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
            VStack(spacing: 20) {
                Image(systemName: iconSystemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color.prime.opacity(0.6))
                    .padding()
                
                Text(LocalizedStringKey(title))
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(.title)
                
                Text(LocalizedStringKey(subtitle))
                    .multilineTextAlignment(.center)
                    .font(.body)
                    .foregroundStyle(.subtitle)
                
            }
            .padding()
            Spacer()
        }
    }
}
