//
//  SideMenuPresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation
import UIKit

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
            let choosenAIType = try await self.loadAIPreferencereType()
            
            guard let selected = aiPreferences.avaibleAI.first(where: { $0.aiType == choosenAIType }) else { return }
            
            let vModel = PreferencesViewModel(chooseAISection: aiPreferences, selectedAI: selected)
            self.delegate?.render(viewModel: vModel)
        } catch {
            print("Error \(error.localizedDescription)")
            self.delegate?.render(errorMessage: error.localizedDescription)
        }
    }
    
    
    public func saveAIPreferencereType(_ aiModel: AIPreferenceModel) {
        Task {
            do {
                try await saveAIPreferencereType(aiModel)
                await loadData()
                updatePreferences()
            } catch {
                debugPrint("Error in save preference \(error.localizedDescription)")
                updatePreferences()
            }
        }
    }
    
    
    internal func saveAIPreferencereType(_ aiModel: AIPreferenceModel) async throws {
        try await service.saveAIPreferencereType(aiModel)
    }
    
    internal func loadAIPreferencereType() async throws -> AIPreferenceType {
        return try await service.loadAIPreferencereType()
    }
}

extension PreferencePresenter: AIModelListDelegate {
    func didSelectModel(_ model: AIPreferenceModel) {
        saveAIPreferencereType(model)
    }
}
