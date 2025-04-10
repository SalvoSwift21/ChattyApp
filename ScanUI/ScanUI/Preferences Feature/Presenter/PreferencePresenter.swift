//
//  SideMenuPresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation
import UIKit
import LLMFeature

public class PreferencePresenter: PreferencePresenterProtocol {
    
    internal var resourceBundle: Bundle

    private var service: AIPreferencesServiceProtocol
    private weak var delegate: PreferenceDelegate?
    public var menuButton: (() -> Void)
    public var updatePreferences: (() -> Void)
    public var privacyButtonTapped: (() -> Void)
    public var storeViewTapped: (() -> Void)
    var currentAppProductFeature: ProductFeature


    public init(delegate: PreferenceDelegate,
                service: AIPreferencesServiceProtocol,
                currentAppProductFeature: ProductFeature,
                privacyButtonTapped: @escaping (() -> Void),
                menuButton: @escaping (() -> Void),
                updatePreferences: @escaping (() -> Void),
                storeViewTapped: @escaping (() -> Void),
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.menuButton = menuButton
        self.updatePreferences = updatePreferences
        self.resourceBundle = bundle
        self.currentAppProductFeature = currentAppProductFeature
        self.privacyButtonTapped = privacyButtonTapped
        self.storeViewTapped = storeViewTapped
    }
    
    @MainActor
    func loadData() async {
        do {
            let aiPreferences = try await service.getAIPreferences()
            let preferenceModel = try await self.loadAIPreferencereType()
            
            guard let selected = aiPreferences.avaibleAI.first(where: { $0.aiType == preferenceModel.selectedAI.aiType }) else { return }
            guard let selectedLanguage = try? selected.aiType.getAllSupportedLanguages().languages.first(where: {$0.locale.identifier == preferenceModel.selectedLanguage.locale.identifier}) else { return }
            
            let allLanguages = try selected.aiType.getAllSupportedLanguages()
            
            let vModel = PreferencesViewModel(aiList: aiPreferences,
                                              selectedAI: selected,
                                              translateLanguage: allLanguages,
                                              selectedLanguage: selectedLanguage,
                                              transactionServiceIsEnabled: transactionServiceIsEnabled())
            
            self.delegate?.render(viewModel: vModel)
        } catch {
            self.delegate?.render(errorState: PreferenceStore.ErrorState.loadPreferenceError(message: error.localizedDescription))
        }
    }
    
    internal func saveAIPreferencereType(_ preferenceModel: PreferenceModel) async throws {
        try await service.saveAIPreferencereType(preferenceModel)
    }
    
    internal func loadAIPreferencereType() async throws -> PreferenceModel {
        return try await service.loadAIPreferencereType()
    }
    
    
    fileprivate func savePreferenceFromAI(_ model: AIPreferenceModel) {
        Task {
            do {
                guard let defaultLanguage = try model.aiType.getAllSupportedLanguages().languages.first else { return }
                let preference = PreferenceModel(selectedLanguage: defaultLanguage, selectedAI: model)
                try await saveAIPreferencereType(preference)
                await loadData()
                updatePreferences()
            } catch {
                await self.delegate?.render(errorState: PreferenceStore.ErrorState.genericError(message: error.localizedDescription))
                updatePreferences()
            }
        }
    }
    
    func transactionServiceIsEnabled() -> Bool {
        currentAppProductFeature.features.contains(where: { $0 == .translation })
    }
    
    fileprivate func savePreferenceFromLanguage(_ model: LLMLanguage) {
        Task {
            do {
                let currentAI = try await loadAIPreferencereType().selectedAI
                let preference = PreferenceModel(selectedLanguage: model, selectedAI: currentAI)
                try await saveAIPreferencereType(preference)
                await loadData()
                updatePreferences()
            } catch {
                await self.delegate?.render(errorState: PreferenceStore.ErrorState.genericError(message: error.localizedDescription))
                updatePreferences()
            }
        }
    }
    
    
    func handleErrorMessageButton(errorState: PreferenceStore.ErrorState) {
        switch errorState {
        case .genericError:
            Task {
                await self.delegate?.render(errorState: nil)
            }
        case .loadPreferenceError:
            Task {
                await loadData()
                await self.delegate?.render(errorState: nil)
            }
        }
    }
    
    func handleNewProductFeature(productFeature: ProductFeature) {
        currentAppProductFeature = productFeature
        Task {
            await loadData()
        }
    }
    
    public func privacySettingTapped() {
        privacyButtonTapped()
    }
    
    public func storeButtonTapped() {
        storeViewTapped()
    }
}

extension PreferencePresenter: AIModelListDelegate {
    func didSelectModel(_ model: AIPreferenceModel) {
        savePreferenceFromAI(model)
    }
}

extension PreferencePresenter: LanguagesListDelegate {
    func didSelectModel(_ model: LLMLanguage) {
        savePreferenceFromLanguage(model)
    }
}
