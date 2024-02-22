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
        text: String,
        back: @escaping () -> Void = {  },
        done: @escaping () -> Void = {  }
    ) -> TextAnalyzerView {
        
        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        let textAnalyzerStore = TextAnalyzerStore()
        
        let openAiClient = makeOpenAIHTTPClient()
        
        let summaryClient = SummaryClient(summariseService: openAiClient)
        let idLanguage = AppleIdentificationLanguage()
        
        let service = TextAnalyzerService(summaryClient: summaryClient, identificationLanguageClient: idLanguage)
        
        let textAnalyzerPresenter = TextAnalyzerPresenter(delegate: textAnalyzerStore, service: service, scannedText: text, bundle: bundle)
        
        return TextAnalyzerView(store: textAnalyzerStore, presenter: textAnalyzerPresenter, resourceBundle: bundle)
    }
}
