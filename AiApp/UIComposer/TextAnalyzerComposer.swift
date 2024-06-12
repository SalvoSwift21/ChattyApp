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
        scanResult: ScanProtocolResult,
        scanStorage: ScanStorege,
        back: @escaping () -> Void = {  },
        done: @escaping () -> Void = {  }
    ) -> TextAnalyzerView {
        
        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        let textAnalyzerStore = TextAnalyzerStore()
        
        let openAiClient = makeOpenAIHTTPClient()
        
        let summaryClient = SummaryClient(summariseService: openAiClient)
        let trClient = TranslateClient(translateService: openAiClient)
        let idLanguage = AppleIdentificationLanguage()
        
        let service = TextAnalyzerService(summaryClient: summaryClient, identificationLanguageClient: idLanguage, translateClient: trClient, storageClient: scanStorage)
        
        let textAnalyzerPresenter = TextAnalyzerPresenter(delegate: textAnalyzerStore, service: service, scannedResult: scanResult, bundle: bundle)
        
        return TextAnalyzerView(store: textAnalyzerStore, presenter: textAnalyzerPresenter, resourceBundle: bundle)
    }
}
