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
    
    let preferencesStoreManager = UserDefaults(suiteName: "PREFERENCES_STORE_MANAGER")
    let purchaseManager: PurchaseManager
    let adMobManager: AdMobManager
    let userMessageManager: UserMessagubgPlatformManager
    var dataConfigurationManager: DataConfigurationManager
    
    private var bootAppIsFinished: Bool = false
    
    var preferenceService: LocalAIPreferencesService
    
    private(set) var currentPreference: PreferenceModel = .init(selectedLanguage: LLMLanguage.init(code: "", name: "", locale: Locale.current, id: UUID()), selectedAI: .init(title: "", imageName: "", aiType: .unowned, maxOutputToken: 0, maxInputToken: 0))
    
    private init() {
        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        preferenceService = LocalAIPreferencesService(resourceBundle: bundle, userDefault: preferencesStoreManager ?? .standard)
        let storeService = StoreService()
        let productFeatureService = ProductFeatureService(resourceBundle: bundle)
        purchaseManager = PurchaseManager(storeService: storeService, productFeatureService: productFeatureService)
        adMobManager = AdMobManager(bannerUnitId: ADUnitIDCode.bannerID.id, interstitialUnitId: ADUnitIDCode.interstitialID.id)
        userMessageManager = UserMessagubgPlatformManager()
        dataConfigurationManager = DataConfigurationManager()
    }
    
    public func bootApp() async throws {
        guard bootAppIsFinished == false else { return }
        try await purchaseManager.startManager()
        try await selectAIIfNeeded()
        
        bootAppIsFinished = true
    }
    
    public func bootSecondaryService() async {
        do {
            try await userMessageManager.askConsentInfo()
            if userMessageManager.canRequestAds {
                try await adMobManager.startManager()
            }
        } catch {
            debugPrint("Error secondry service: \(error)")
        }
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
    
    fileprivate func selectAIIfNeeded() async throws {
        let allAI = try await preferenceService.getAIPreferences()
        
        
        guard let defaultAI = allAI.avaibleAI.first(where: { $0.aiType.isEnabledFor(productID: purchaseManager.currentAppProductFeature.productID ) }) else {
            fatalError("No AI Avaible")
        }
        
        guard let defaultLanguage = try defaultAI.aiType.getAllSupportedLanguages().languages.first else {
            fatalError("No supported Language")
        }
        
        let result = try? await preferenceService.loadAIPreferencereType()
        
        guard let result = result else {
            let preference: PreferenceModel = PreferenceModel.init(selectedLanguage: defaultLanguage, selectedAI: defaultAI)
            try await preferenceService.saveAIPreferencereType(preference)
            self.updatePreference(with: preference)
            return
        }
        
        self.updatePreference(with: result)
    }
}
