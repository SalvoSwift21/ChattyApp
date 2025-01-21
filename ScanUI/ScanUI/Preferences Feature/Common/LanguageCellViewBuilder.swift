//
//  AICellViewBuilder 2.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/01/25.
//


import Foundation
import SwiftUI
import LLMFeature

class LanguageCellViewBuilder {
    
    @ViewBuilder
    func languageCell(model: LLMLanguage, isSelected: Bool) -> some View {
        HStack(alignment: .center, spacing: 8) {
            Text("\(flag(from: model.locale) ?? "")")
                .font(.title)
                .multilineTextAlignment(.leading)
            Text("\(model.name)")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.title)
                .lineLimit(1)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.prime)
            }
        }
    }
    
    fileprivate func flag(from locale: Locale) -> String? {
        guard let countryCode = locale.region?.identifier else {
            return nil
        }
        
        return countryCode.unicodeScalars.reduce("") { (flag, scalar) in
            guard let scalarValue = UnicodeScalar(127397 + scalar.value) else {
                return flag
            }
            return flag + String(scalarValue)
        }
    }
}
