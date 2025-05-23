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
                            .overlay {
                                if !ai.aiType.isEnabledFor(productID: currentAppProductFeature.productID) {
                                    ZStack(alignment: .topTrailing) {
                                        LinearGradient(
                                            colors: [Color.gray.opacity(0.45), Color.prime.opacity(0.25)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                        .edgesIgnoringSafeArea(.all)
                                        
                                        Image(systemName: "lock.fill")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(
                                                Circle()
                                                    .fill(Color.black.opacity(0.4))
                                            )
                                            .padding()
                                        
                                    }.clipShape(.buttonBorder)
                                }
                            }
                        }
                    })
                    .padding()
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("CHOOSE_AI_MODEL_TITLE")
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
        AiModelListView(currentAppProductFeature: currentAppProductFeature, models: [], selected: AIPreferenceModel(title: "", imageName: "", aiType: .gemini_2_0_flash, maxOutputToken: 100, maxInputToken: 100), resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main, delegate: FakeDelegate())
    }
    
}


class FakeDelegate: AIModelListDelegate {
    func didSelectModel(_ model: AIPreferenceModel) { }
}
