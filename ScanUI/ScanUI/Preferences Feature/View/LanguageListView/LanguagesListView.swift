//
//  AIModelListDelegate.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 17/01/25.
//


import Foundation
import SwiftUI
import LLMFeature

protocol LanguagesListDelegate: AnyObject {
    func didSelectModel(_ model: LLMLanguage)
}

public struct LanguagesListView: View {
    
    @Environment(\.dismiss) var dismiss

    var models: [LLMLanguage]
    var selected: LLMLanguage
    var resourceBundle: Bundle
    
    var delegate: LanguagesListDelegate
    
    public var body: some View {
        NavigationView {
            List {
                ForEach(models, id: \.id) { language in
                    Button {
                        delegate.didSelectModel(language)
                        dismiss()
                    } label: {
                        LanguageCellViewBuilder().languageCell(model: language, isSelected: language.id == selected.id)
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Choose language")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Text("Close")
                                .foregroundStyle(.prime)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    return LanguagesListView(models: FakeLanguagesListDelegate.fakeList, selected: FakeLanguagesListDelegate.fakeList.first!, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main, delegate: FakeLanguagesListDelegate())
}


class FakeLanguagesListDelegate: LanguagesListDelegate {
    static var fakeList: [LLMLanguage] = [
        LLMLanguage(code: "en", name: "English", locale: Locale.init(identifier: "en_US")),
        LLMLanguage(code: "es", name: "Español", locale: Locale.init(identifier: "es_ES")),
    ]
            
    func didSelectModel(_ model: LLMLanguage) { }
}
