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
    private let identificationLanguageClient: IdentificationLanguageProtocol
    let storageClient: ScanStorege
   
    public init(summaryClient: SummaryClientProtocol, identificationLanguageClient: IdentificationLanguageProtocol, storageClient: ScanStorege) {
        self.summaryClient = summaryClient
        self.identificationLanguageClient = identificationLanguageClient
        self.storageClient = storageClient
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
