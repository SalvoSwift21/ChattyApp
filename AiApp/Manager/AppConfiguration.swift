//
//  AppConfiguration.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 1/24/25.
//

import SwiftUI
import RestApi
import ScanUI
import VisionKit
import LLMFeature


public class AppConfiguration {
    
    static public var shared = AppConfiguration()
    
    static let appGroupName = "group.com.ariel.ai.scan.app"
    static let defaultFolderName = String(localized: "DEFAULT_FOLDER_NAME")
    
    let preferencesStoreManager = UserDefaults(suiteName: "PREFERENCES_STORE_MANAGER")
    
    var storeURL: URL = {
        guard var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppConfiguration.appGroupName) else {
            return URL(string: "Test")!
        }
        let storeURLResult = storeURL.appendingPathComponent("AI.SCAN.sqlite")
        return storeURLResult
    }()
    
    var preferenceService: LocalAIPreferencesService
    
    private(set) var currentPreference: PreferenceModel = .init(selectedLanguage: LLMLanguage.init(code: "", name: "", locale: Locale.current, id: UUID()), selectedAI: .unowned)
    
    private init() { 
        preferenceService = LocalAIPreferencesService(resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main, userDefault: preferencesStoreManager ?? .standard)
    }
    
    public func bootApp() async {
        await selectAIIfNeeded()
    }
    
    public func updatePreferences() {
        Task {
            guard let result = try? await preferenceService.loadAIPreferencereType() else { return }
            self.updatePreference(with: result)
        }
    }
    
    fileprivate func updatePreference(with preference: PreferenceModel) {
        self.currentPreference = preference
    }
    
    fileprivate func selectAIIfNeeded() async {
        do {
            let allAI = try await preferenceService.getAIPreferences()
            
            guard let defaultAI = allAI.avaibleAI.first else {
                fatalError("No AI Avaible")
            }
            
            guard let defaultLanguage = try defaultAI.aiType.getAllSupportedLanguages().languages.first else {
                fatalError("No supported Language")
            }
            
            let result = try? await preferenceService.loadAIPreferencereType()
            
            guard let result = result else {
                let preference: PreferenceModel = PreferenceModel.init(selectedLanguage: defaultLanguage, selectedAI: defaultAI.aiType)
                try await preferenceService.saveAIPreferencereType(preference)
                self.updatePreference(with: preference)
                return
            }
            
            self.updatePreference(with: result)
            
        } catch {
            fatalError("No AI Avaible")
        }
    }
}
