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
    @State private var searchText: String = ""
    
    private var models: [LLMLanguage]
    private var selected: LLMLanguage
    private var resourceBundle: Bundle
    
    private var delegate: LanguagesListDelegate
    
    private var searchResults: [LLMLanguage] {
        if searchText.isEmpty {
            return models
        } else {
            return models.filter { $0.name.contains(searchText) }
        }
    }
    
    init(models: [LLMLanguage], selected: LLMLanguage, resourceBundle: Bundle, delegate: LanguagesListDelegate) {
        self.models = models
        self.selected = selected
        self.resourceBundle = resourceBundle
        self.delegate = delegate
    }
    
    public var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.id) { language in
                    Button {
                        delegate.didSelectModel(language)
                        dismiss()
                    } label: {
                        VStack {
                            LanguageCellViewBuilder().languageCell(model: language, isSelected: language.code == selected.code)
                        }
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
        .searchable(text: $searchText, prompt: "Search your favorite language")
    }
    
}

#Preview {
    return LanguagesListView(models: FakeLanguagesListDelegate.fakeList, selected: FakeLanguagesListDelegate.fakeList.first!, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main, delegate: FakeLanguagesListDelegate())
}


class FakeLanguagesListDelegate: LanguagesListDelegate {
    static var fakeList: [LLMLanguage] = [
        LLMLanguage(code: "en", name: "English", locale: Locale.init(identifier: "en_US"), id: UUID()),
        LLMLanguage(code: "es", name: "Español", locale: Locale.init(identifier: "es_ES"), id: UUID()),
    ]
            
    func didSelectModel(_ model: LLMLanguage) { }
}
