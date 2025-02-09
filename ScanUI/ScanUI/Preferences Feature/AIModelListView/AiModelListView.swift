//
//  AiModelListView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 16/01/25.
//

import Foundation
import SwiftUI

protocol AIModelListDelegate: AnyObject {
    func didSelectModel(_ model: AIPreferenceModel)
}

public struct AiModelListView: View {
    
    @Environment(\.dismiss) var dismiss
    var currentAppProductFeature: ProductFeature

    var models: [AIPreferenceModel]
    var selected: AIPreferenceModel
    var resourceBundle: Bundle
    
    var delegate: AIModelListDelegate
    
    public var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20, content: {
                        ForEach(models, id: \.id) { ai in
                            Button {
                                delegate.didSelectModel(ai)
                                dismiss()
                            } label: {
                                AICellViewBuilder().AiCell(model: ai, isSelected: selected.aiType == ai.aiType, resourceBundle: resourceBundle)
                            }
                            .disabled(!ai.aiType.isEnabledFor(productID: currentAppProductFeature.productID))
                            .opacity(ai.aiType.isEnabledFor(productID: currentAppProductFeature.productID) ? 1 : 0.5)
                        }
                    })
                    .padding()
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("AI Model list")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Text("Close")
                                    .foregroundStyle(.primary)
                            }
                        }
                    }
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .top
            )
            .background(.clear)
        }
    }
}

#Preview {
    var currentAppProductFeature: ProductFeature = ProductFeature(features: [.complexAIModel], productID: "")

    NavigationView {
        AiModelListView(currentAppProductFeature: currentAppProductFeature, models: [], selected: AIPreferenceModel(title: "", imageName: "", aiType: .gemini_1_5_flash), resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main, delegate: FakeDelegate())
    }
    
}


class FakeDelegate: AIModelListDelegate {
    func didSelectModel(_ model: AIPreferenceModel) { }
}
