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
        done: @escaping () -> Void = {  }
    ) -> TextAnalyzerView? {
        
        guard let fileType = scanResult.getFileUTType() else { return nil  }
        guard let client = TextAnalyzerComposer.chooseClient(fileType: fileType) else { return nil}

        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        let textAnalyzerStore = TextAnalyzerStore()
                
        let summaryClient = SummaryClient(summariseService: client)
        let trClient = TranslateClient(translateService: client, localeToTranslate: TextAnalyzerComposer.getCurrentTranslationLanguage())
        let idLanguage = AppleIdentificationLanguage()
        
        let service = TextAnalyzerService(summaryClient: summaryClient, identificationLanguageClient: idLanguage, translateClient: trClient, storageClient: scanStorage)
        
        let textAnalyzerPresenter = TextAnalyzerPresenter(delegate: textAnalyzerStore, service: service, scannedResult: scanResult, done: done, bundle: bundle)
        
        return TextAnalyzerView(store: textAnalyzerStore, presenter: textAnalyzerPresenter, resourceBundle: bundle)
    }
    
    fileprivate static func chooseClient(fileType: UTType) -> (SummaryServiceProtocol & TranslateServiceProtocol)? {
        var client: SummaryServiceProtocol & TranslateServiceProtocol
        let currentAi = AppConfiguration.shared.currentPreference.selectedAI
        
        guard currentAi.getAISupportedFileTypes().contains(fileType) else {
            return nil
        }
        
        switch currentAi {
        case .gpt_4_o, .gpt_4o_mini:
            client = makeOpenAIHTTPClient(modelName: currentAi.rawValue)
        case .gemini_1_5_flash, .gemini_pro, .gemini_1_5_flash_8b:
            switch fileType {
            case .image, .jpeg, .png:
                client = makeGoogleGeminiAIClient(modelName: currentAi.rawValue) as GoogleAILLMClient
            default:
                client = makeGoogleGeminiAIClient(modelName: currentAi.rawValue) as GoogleAIFileSummizeClient
            }
        case .unowned:
            fatalError("Not AI selected")
        }

        return client
    }
    
    fileprivate static func getCurrentTranslationLanguage() -> Locale {
        return AppConfiguration.shared.currentPreference.selectedLanguage.locale
    }
}
