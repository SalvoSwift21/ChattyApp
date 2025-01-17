//
//  AICellViewBuilder.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 16/01/25.
//

import Foundation
import SwiftUI


class AICellViewBuilder {
    
    @ViewBuilder
    func AiCell(model: AIPreferenceModel, isSelected: Bool, resourceBundle: Bundle) -> some View {
        HStack(alignment: .top) {
            Image(model.imageName, bundle: resourceBundle)
                .resizable()
                .frame(width: 20, height: 20, alignment: .center)
            
            VStack(alignment: .leading, spacing: 3, content: {
                Text(model.title)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundStyle(.title)
                
                Text(model.aiType.getDescription())
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 12))
                    .fontWeight(.regular)
                    .foregroundStyle(.subtitle)
            })
            
            Spacer()
        }
        .padding()
        .background(.white)
        .clipShape(.buttonBorder)
        .overlay(
            RoundedRectangle(cornerRadius: 16.0)
                .stroke(.prime.opacity(0.5), lineWidth: isSelected ? 1 : 0)
        )
        .shadow(color: isSelected ? .prime.opacity(0.5) : .gray.opacity(0.4), radius: 8.0, x: 0.0, y: 0.0)
    }
}
