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

public final class TextAnalyzerComposer {
    
    private init() {}
        
    public static func textAnalyzerComposedWith(
        scanResult: ScanResult,
        scanStorage: ScanStorege,
        done: @escaping () -> Void = {  }
    ) -> TextAnalyzerView {
        
        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        let textAnalyzerStore = TextAnalyzerStore()
        
        var client: SummaryServiceProtocol & TranslateServiceProtocol
        
        switch AppConfiguration.shared.currentSelectedAI {
        case .gpt_4_o, .gpt_4o_mini:
            client = makeOpenAIHTTPClient(modelName: AppConfiguration.shared.currentSelectedAI.rawValue)
        case .gemini_1_5_flash, .gemini_pro, .gemini_1_5_flash_8b:
            client = makeGoogleGeminiAIClient(modelName: AppConfiguration.shared.currentSelectedAI.rawValue)
        case .unowned:
            fatalError("Not AI selected")
        }
                
        let summaryClient = SummaryClient(summariseService: client)
        let trClient = TranslateClient(translateService: client)
        let idLanguage = AppleIdentificationLanguage()
        
        let service = TextAnalyzerService(summaryClient: summaryClient, identificationLanguageClient: idLanguage, translateClient: trClient, storageClient: scanStorage)
        
        let textAnalyzerPresenter = TextAnalyzerPresenter(delegate: textAnalyzerStore, service: service, scannedResult: scanResult, done: done, bundle: bundle)
        
        return TextAnalyzerView(store: textAnalyzerStore, presenter: textAnalyzerPresenter, resourceBundle: bundle)
    }
}
