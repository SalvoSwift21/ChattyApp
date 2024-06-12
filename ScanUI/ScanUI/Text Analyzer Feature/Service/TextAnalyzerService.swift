//
//  SummaryService.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 08/02/24.
//

import Foundation
import SummariseTranslateFeature

public class TextAnalyzerService: TextAnalyzerServiceProtocol {
    
    private enum TextAnalyzerServiceError: Swift.Error {
        case noDefaultFolder
    }
    
    private let summaryClient: SummaryClientProtocol
    private let translateClient: TranslateClientProtocol
    private let identificationLanguageClient: IdentificationLanguageProtocol
    let storageClient: ScanStorege
   
    public init(summaryClient: SummaryClientProtocol,
                identificationLanguageClient: IdentificationLanguageProtocol,
                translateClient: TranslateClientProtocol,
                storageClient: ScanStorege) {
        self.summaryClient = summaryClient
        self.identificationLanguageClient = identificationLanguageClient
        self.translateClient = translateClient
        self.storageClient = storageClient
    }
    
    
    public func makeSummary(forText text: String) async throws -> String {
        try await summaryClient.makeSummary(fromText: text)
    }
    
    public func makeTranslation(forText text: String, to locale: Locale) async throws -> String {
        
        let currentLanguage = try self.identificationLanguageClient.identifyLanguage(fromText: text)
        
        guard currentLanguage != locale.identifier else { return text }
        
        let translate = try await self.translateClient.translate(fromText: text, to: locale)

        return translate
    }
    
    public func saveCurrentScan(scan: Scan, folder: Folder? = nil) async throws {
        var saveFolder: Folder
        
        if folder == nil {
            saveFolder = try getDefaultFolder()
        } else {
            saveFolder = folder!
        }
        
        try storageClient.insert(scan, inFolder: saveFolder)
    }
    
    private func getDefaultFolder() throws -> Folder {
        guard let folder = try storageClient.retrieveFolder(title: "Default Folder") else {
            throw TextAnalyzerServiceError.noDefaultFolder
        }
        return folder
    }
}
