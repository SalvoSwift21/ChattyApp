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
    @EnvironmentObject
    private var purchaseManager: PurchaseManager

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
                        VStack(spacing: 40) {
                            ChooseAISection(viewModel: viewModel)
                            TransactionSection(viewModel: viewModel)
                            PrivacySection()
                        }
                        .padding()
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
        .onChange(of: purchaseManager.currentAppProductFeature) {
            presenter.handleNewProductFeature(productFeature: purchaseManager.currentAppProductFeature)
        }
    }
    
    @ViewBuilder
    func ChooseAISection(viewModel: PreferencesViewModel) -> some View {
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
    }
    
    @ViewBuilder
    func TransactionSection(viewModel: PreferencesViewModel) -> some View {
        VStack {
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
            .padding(!viewModel.transactionServiceIsEnabled ? 8 : 0)
        }
        .overlay(
            ZStack(alignment: .topTrailing) {
                if !viewModel.transactionServiceIsEnabled {
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
                }
            }
            .clipShape(.rect(cornerRadius: 8))
            .padding(.vertical, -15)
            .padding(.horizontal, -4)
        )
    }
    
    @ViewBuilder
    func PrivacySection() -> some View {
        Section {
            VStack(spacing: 0) {
                Button {
                    presenter.privacySettingTapped()
                } label: {
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: "shield.lefthalf.filled")
                            .foregroundColor(.prime)
                            .frame(width: 24, height: 24)
                        
                        Text("PREFERENCES_PRIVACY_BUTTON")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.title)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                .padding()

                Divider()
                Button {
                    presenter.storeButtonTapped()
                } label: {
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: "crown")
                            .foregroundColor(.prime)
                            .frame(width: 24, height: 24)
                        
                        Text("PREFERENCES_MEMBERSHIP_BUTTON")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.title)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                .padding()

            }
            .background(.white)
            .clipShape(.rect(cornerRadius: 8))
            .shadow(color: .gray.opacity(0.4), radius: 8.0, x: 0.0, y: 0.0)
            
        } header: {
            HStack {
                VStack(alignment: .leading, spacing: 5.0) {
                    Text("PREFERENCES_PRIVACY_TITLE")
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundStyle(.title)
                    
                    Text("PREFERENCES_PRIVACY_DESCRIPTION")
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 14))
                        .fontWeight(.regular)
                        .foregroundStyle(.subtitle)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    var preferenceStore = PreferenceStore()
    
    let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    
    var service = LocalAIPreferencesService(resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main, userDefault: UserDefaults.standard, aiPreference: AIPreferenceModel(title: "", imageName: "", aiType: .gemini_2_0_flash, maxOutputToken: 0, maxInputToken: 0))
    var currentAppProductFeature: ProductFeature = ProductFeature(features: [.complexAIModel], productID: "")
    
    var presenter = PreferencePresenter(delegate: preferenceStore, service: service, currentAppProductFeature: currentAppProductFeature, privacyButtonTapped: { }, menuButton: { }, updatePreferences: { }, storeViewTapped: { })
    
    NavigationView {
        PreferencesView(store: preferenceStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
            .navigationTitle("Preferences")
    }
}
