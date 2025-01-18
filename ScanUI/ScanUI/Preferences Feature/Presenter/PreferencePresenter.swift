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


    public init(delegate: PreferenceDelegate,
                service: AIPreferencesServiceProtocol,
                menuButton: @escaping (() -> Void),
                updatePreferences: @escaping (() -> Void),
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.menuButton = menuButton
        self.updatePreferences = updatePreferences
        self.resourceBundle = bundle
    }
    
    @MainActor
    func loadData() async {
        do {
            let aiPreferences = try await service.getAIPreferences()
            let preferenceModel = try await self.loadAIPreferencereType()
            
            guard let selected = aiPreferences.avaibleAI.first(where: { $0.aiType == preferenceModel.selectedAI }) else { return }
            guard let selectedLanguage = try? selected.aiType.getAllSupportedLanguages().languages.first(where: {$0.locale.identifier == preferenceModel.selectedLanguage.locale.identifier}) else { return }
            
            let allLanguages = try selected.aiType.getAllSupportedLanguages()
            
            let vModel = PreferencesViewModel(aiList: aiPreferences,
                                              selectedAI: selected,
                                              translateLanguage: allLanguages,
                                              selectedLanguage: selectedLanguage)
            
            self.delegate?.render(viewModel: vModel)
        } catch {
            print("Error \(error.localizedDescription)")
            self.delegate?.render(errorMessage: error.localizedDescription)
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
                let preference = PreferenceModel(selectedLanguage: defaultLanguage, selectedAI: model.aiType)
                try await saveAIPreferencereType(preference)
                await loadData()
                updatePreferences()
            } catch {
                debugPrint("Error in save preference \(error.localizedDescription)")
                updatePreferences()
            }
        }
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
                debugPrint("Error in save preference \(error.localizedDescription)")
                updatePreferences()
            }
        }
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
