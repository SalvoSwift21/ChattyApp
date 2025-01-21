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
        case noCorrectClient
    }
    
    private let summaryClient: SummaryClientProtocol
    private let translateClient: TranslateClientProtocol
    let storageClient: ScanStorege
   
    public init(summaryClient: SummaryClientProtocol,
                translateClient: TranslateClientProtocol,
                storageClient: ScanStorege) {
        self.summaryClient = summaryClient
        self.translateClient = translateClient
        self.storageClient = storageClient
    }
    
    
    public func makeSummary(forText text: String) async throws -> String {
        try await summaryClient.makeSummary(fromText: text)
    }
    
    public func makeSummary(forData data: Data, mimeType: String) async throws -> String {
        try await summaryClient.makeSummary(forData: data, mimeType: mimeType)
    }
    
    public func makeTranslation(forText text: String) async throws -> String {
        return try await self.translateClient.translate(fromText: text)
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
        guard let folder = try storageClient.retrieveFolders(title: storageClient.getDefaultFolderName())?.first else {
            throw TextAnalyzerServiceError.noDefaultFolder
        }
        return folder
    }
}
