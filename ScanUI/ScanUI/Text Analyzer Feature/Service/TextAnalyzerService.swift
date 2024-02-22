//
//  SummaryService.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 08/02/24.
//

import Foundation
import SummariseTranslateFeature

public class TextAnalyzerService: TextAnalyzerServiceProtocol {
    
    let summaryClient: SummaryClientProtocol
    let identificationLanguageClient: IdentificationLanguageProtocol

    
    public init(summaryClient: SummaryClientProtocol, identificationLanguageClient: IdentificationLanguageProtocol) {
        self.summaryClient = summaryClient
        self.identificationLanguageClient = identificationLanguageClient
    }
    
    
    public func makeSummary(forText text: String) async throws -> String {
        try await summaryClient.makeSummary(fromText: text)
    }
    
    public func getCurrentLanguage(forText text: String) async throws -> String {
        try self.identificationLanguageClient.identifyLanguageProtocol(fromText: text)
    }
    
    public func makeTranslation(forText text: String, from: Locale, to: Locale) async throws -> String {
        print("not used for now")
        return ""
    }
}
