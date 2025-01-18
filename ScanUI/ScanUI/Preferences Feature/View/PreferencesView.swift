//
//  PreferencesView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 23/10/24.
//

import Foundation
import SwiftUI


public struct PreferencesView: View {
    
    var presenter: PreferencePresenter
    @ObservedObject var store: PreferenceStore
    @State var showAiModelsList: Bool = false
    @State var showLanguagesModelsList: Bool = false

    var resourceBundle: Bundle

    
    public init(store: PreferenceStore, presenter: PreferencePresenter, resourceBundle: Bundle = .main) {
        self.store = store
        self.presenter = presenter
        self.resourceBundle = resourceBundle
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            switch store.state {
            case .unowned:
                EmptyView()
            case .error(let message):
                ErrorView(title: "Error", description: message, primaryButtonTitle: "Try with another file", primaryAction: {
                    Task {
                        await presenter.loadData()
                    }
                }, secondaryButtonTitle: nil, secondaryAction: nil)
            case .loaded(let viewModel):
                ScrollView {
                    Section {
                        Button {
                            showAiModelsList.toggle()
                        } label: {
                            AICellViewBuilder().AiCell(model: viewModel.selectedAI, isSelected: true, resourceBundle: resourceBundle)
                        }
                    } header: {
                        VStack(alignment: .leading, spacing: 5.0) {
                            Text("Modello AI")
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                                .foregroundStyle(.title)
                            
                            Text("Qui potrai scegliere quale modello di AI vuoi utilizzare per fare riassunti e/o traduzioni")
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 12))
                                .fontWeight(.regular)
                                .foregroundStyle(.subtitle)
                        }
                    }
                    .padding()
                    
                    Section {
                        Button {
                            showLanguagesModelsList.toggle()
                        } label: {
                            LanguageCellViewBuilder().languageCell(model: viewModel.selectedLanguage, isSelected: true)
                        }
                    } header: {
                        VStack(alignment: .leading, spacing: 5.0) {
                            Text("Lingua")
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                                .foregroundStyle(.title)
                            
                            Text("Qui puoi scegliere la lingua di default con cui vuoi fare le traduzioni")
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 14))
                                .fontWeight(.regular)
                                .foregroundStyle(.subtitle)
                        }
                    }
                    .padding()
                }
                .listStyle(.sidebar)
                .scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        HStack {
                            Button {
                                presenter.menuButton()
                            } label: {
                                Image("menu_icon", bundle: resourceBundle)
                            }
                        }
                    }
                }
                .sheet(isPresented: $showAiModelsList) {
                    AiModelListView(models: viewModel.aiList.avaibleAI, selected: viewModel.selectedAI, resourceBundle: resourceBundle, delegate: presenter)
                }
                .sheet(isPresented: $showLanguagesModelsList) {
                    LanguagesListView(models: viewModel.translateLanguage.languages, selected: viewModel.selectedLanguage, resourceBundle: resourceBundle, delegate: presenter)
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .background(.clear)
        .task {
            await presenter.loadData()
        }
    }
}

#Preview {
    var preferenceStore = PreferenceStore()
    
    let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    
    var service = LocalAIPreferencesService(resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main, userDefault: UserDefaults.standard, aiPreference: AIPreferenceModel(title: "", imageName: "", aiType: .gemini_1_5_flash))
    
    var presenter = PreferencePresenter(delegate: preferenceStore, service: service, menuButton: { }, updatePreferences: { })
    
    return NavigationView {
        PreferencesView(store: preferenceStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
            .navigationTitle("Preferences")
    }
}
