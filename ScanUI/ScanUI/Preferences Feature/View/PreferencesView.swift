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
    @State var showAiModelsListHelper: Bool = false
    @State var showLanguagesModelsList: Bool = false
    @State var showLanguagesHelper: Bool = false

    var resourceBundle: Bundle

    
    public init(store: PreferenceStore, presenter: PreferencePresenter, resourceBundle: Bundle = .main) {
        self.store = store
        self.presenter = presenter
        self.resourceBundle = resourceBundle
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .center) {
                switch store.state {
                case .unowned:
                    EmptyView()
                case .loaded(let viewModel):
                    ScrollView {
                        Section {
                            Button {
                                showAiModelsList.toggle()
                            } label: {
                                AICellViewBuilder().AiCell(model: viewModel.selectedAI, isSelected: true, resourceBundle: resourceBundle)
                            }
                        } header: {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 5.0) {
                                    Text("PREFERENCES_CHOOSE_AI_TITLE")
                                        .multilineTextAlignment(.leading)
                                        .font(.system(size: 18))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.title)
                                    
                                    Text("PREFERENCES_CHOOSE_AI_MESSAGE")
                                        .multilineTextAlignment(.leading)
                                        .font(.system(size: 12))
                                        .fontWeight(.regular)
                                        .foregroundStyle(.subtitle)
                                }
                                
                                Spacer()
                                
                                Button {
                                    showAiModelsListHelper.toggle()
                                } label: {
                                    Image(systemName: "info.circle")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 20, height: 20, alignment: .center)
                                        .foregroundStyle(.prime)
                                }
                            }
                        }
                        .padding()
                        
                        if viewModel.transactionServiceIsEnabled {
                            Section {
                                Button {
                                    showLanguagesModelsList.toggle()
                                } label: {
                                    LanguageCellViewBuilder().languageCell(model: viewModel.selectedLanguage, isSelected: true)
                                        .padding()
                                        .background(.white)
                                        .clipShape(.buttonBorder)
                                        .shadow(color: .gray.opacity(0.4), radius: 8.0, x: 0.0, y: 0.0)
                                }
                            } header: {
                                HStack(alignment: .top) {
                                    
                                    VStack(alignment: .leading, spacing: 5.0) {
                                        Text("PREFERENCES_CHOOSE_LANGUAGE_TITLE")
                                            .multilineTextAlignment(.leading)
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.title)
                                        
                                        Text("PREFERENCES_CHOOSE_LANGUAGE_MESSAGE")
                                            .multilineTextAlignment(.leading)
                                            .font(.system(size: 14))
                                            .fontWeight(.regular)
                                            .foregroundStyle(.subtitle)
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        showLanguagesHelper.toggle()
                                    } label: {
                                        Image(systemName: "info.circle")
                                            .renderingMode(.template)
                                            .resizable()
                                            .frame(width: 20, height: 20, alignment: .center)
                                            .foregroundStyle(.prime)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    .listStyle(.sidebar)
                    .scrollContentBackground(.hidden)
                    .sheet(isPresented: $showAiModelsList) {
                        AiModelListView(currentAppProductFeature: presenter.currentAppProductFeature, models: viewModel.aiList.avaibleAI, selected: viewModel.selectedAI, resourceBundle: resourceBundle, delegate: presenter)
                    }
                    .sheet(isPresented: $showLanguagesModelsList) {
                        LanguagesListView(models: viewModel.translateLanguage.languages, selected: viewModel.selectedLanguage, resourceBundle: resourceBundle, delegate: presenter)
                    }
                    .sheet(isPresented: $showAiModelsListHelper) {
                        AIPreferenceHelpView(title: "PREFERENCES_CHOOSE_AI_INFO_TITLE", subtitle: "PREFERENCES_CHOOSE_AI_INFO_DESCRIPTION")
                    }
                    .sheet(isPresented: $showLanguagesHelper) {
                        AIPreferenceHelpView(title: "PREFERENCES_CHOOSE_LA_INFO_DESCRIPTION", subtitle: "PREFERENCES_CHOOSE_LA_INFO_TITLE")
                    }
                }
            }
            
            if let errorState = store.errorState {
                Color
                    .scanBackground
                    .opacity(0.15)
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        self.presenter.handleErrorMessageButton(errorState: errorState)
                    }
                
                ErrorView(title: "GENERIC_ERROR_TITLE", description: errorState.getMessage(), primaryButtonTitle: errorState.getSubMess(), primaryAction: {
                    presenter.handleErrorMessageButton(errorState: errorState)
                }, secondaryButtonTitle: nil, secondaryAction: nil)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("SIDE_MENU_CHOOSE_AI")
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
    
    var service = LocalAIPreferencesService(resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main, userDefault: UserDefaults.standard, aiPreference: AIPreferenceModel(title: "", imageName: "", aiType: .gemini_2_0_flash, maxOutputToken: 0, maxInputToken: 0))
    var currentAppProductFeature: ProductFeature = ProductFeature(features: [.complexAIModel], productID: "")
    
    var presenter = PreferencePresenter(delegate: preferenceStore, service: service, currentAppProductFeature: currentAppProductFeature, menuButton: { }, updatePreferences: { })
    
    return NavigationView {
        PreferencesView(store: preferenceStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
            .navigationTitle("Preferences")
    }
}
