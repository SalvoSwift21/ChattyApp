//
//  TextAnalyzerComposer.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 13/02/24.
//

import Foundation
import ScanUI
import GoogleAIFeature
import SummariseTranslateFeature
import OpenAIFeature
import UniformTypeIdentifiers

public final class TextAnalyzerComposer {
    
    private init() {}
    

    public static func textAnalyzerComposedWith(
        scanResult: ScanResult,
        scanStorage: ScanStorege,
        done: @escaping () -> Void = {  },
        storeViewButtonTapped: @escaping () -> Void = { }
    ) -> TextAnalyzerView? {
        
        guard let fileType = scanResult.getFileUTType() else { return nil  }
        guard let client = TextAnalyzerComposer.chooseClient(fileType: fileType) else { return nil}

        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        let textAnalyzerStore = TextAnalyzerStore()
                
        let summaryClient = SummaryClient(summariseService: client)
        let idLanguage = AppleIdentificationLanguage()
        let trClient = TranslateClient(translateService: client, identificationLanguageClient: idLanguage, localeToTranslate: TextAnalyzerComposer.getCurrentTranslationLanguage())
        
        let service = TextAnalyzerService(summaryClient: summaryClient, translateClient: trClient, storageClient: scanStorage)
        
        let textAnalyzerPresenter = TextAnalyzerPresenter(delegate: textAnalyzerStore, service: service, scannedResult: scanResult, currentProductFeature: AppConfiguration.shared.purchaseManager.currentAppProductFeature, bannerID: AppConfiguration.shared.adMobManager.getBannerUnitId(), bundle: bundle, done: done, storeViewTapped: storeViewButtonTapped)
        
        return TextAnalyzerView(store: textAnalyzerStore, presenter: textAnalyzerPresenter, resourceBundle: bundle)
    }
    
    fileprivate static func chooseClient(fileType: UTType) -> (SummaryServiceProtocol & TranslateServiceProtocol)? {
        var client: SummaryServiceProtocol & TranslateServiceProtocol
        let currentAi = AppConfiguration.shared.currentPreference.selectedAI
        let currentProductFeature = AppConfiguration.shared.purchaseManager.currentAppProductFeature
        
        guard currentAi.aiType.getAISupportedFileTypes(forProductFeature: currentProductFeature).contains(fileType) else {
            return nil
        }
        
        switch currentAi.aiType {
        case .gpt_4_o, .gpt_4o_mini:
            var maxInputToken: Int = currentProductFeature.getMaxResourceToken()
            
            if let _ = currentProductFeature.features.filter({ $0 == .complexSummaryMaxTokenAvaible }).first {
                maxInputToken = currentAi.maxInputToken
            }
            
            client = makeOpenAIHTTPClient(modelName: currentAi.aiType.rawValue, maxInputToken: maxInputToken, maxOutputToken: currentAi.maxOutputToken)
        case .gemini_2_0_flash, .gemini_pro, .gemini_2_0_flash_lite:
            var maxResourceToken: Int = currentProductFeature.getMaxResourceToken()
            
            if let _ = currentProductFeature.features.filter({ $0 == .complexSummaryMaxTokenAvaible }).first {
                maxResourceToken = currentAi.maxInputToken
            }
            
            client = makeGoogleGeminiAIClient(modelName: currentAi.aiType.rawValue, maxResourceToken: maxResourceToken)
        case .unowned:
            fatalError("Not AI selected")
        }

        return client
    }
    
    fileprivate static func getCurrentTranslationLanguage() -> Locale {
        return AppConfiguration.shared.currentPreference.selectedLanguage.locale
    }
}
