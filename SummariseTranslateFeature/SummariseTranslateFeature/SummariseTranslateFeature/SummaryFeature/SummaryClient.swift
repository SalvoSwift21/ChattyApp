//
//  Summarise.swift
//  SummariseTranslateFeature
//
//  Created by Salvatore Milazzo on 05/02/24.
//

import Foundation
import LLMFeature
import GoogleAIFeature
import OpenAIFeature
import PDFKit

public class SummaryClient: SummaryClientProtocol {
    
    public enum SummaryClientError: Error {
        case invalidData
        case invalidClient
    }
    
    var summariseService: SummaryServiceProtocol
    
    public init(summariseService: SummaryServiceProtocol) {
        self.summariseService = summariseService
    }
    
    public func makeSummary(fromText text: String) async throws -> String {
        let summPrompt = "Summarise the following text: \(text)"
        return try await self.summariseService.makeSummary(fromText: summPrompt)
    }
    
    public func makeSummary(forData data: Data, mimeType: String) async throws -> String {
        let summPrompt = "Summarize the following text highlighting the main arguments"
        return try await summariseService.makeFileSummary(fromText: summPrompt, data: data, mimeType: mimeType)
    }
}

extension GoogleAILLMClient: SummaryServiceProtocol {
    
    public func makeFileSummary(fromText text: String, data: Data, mimeType: String) async throws -> String {
        let fileData = DataGenAiThrowingPartsRepresentable(data: data, preferredMIMEType: mimeType)
        let message = GoogleFileLLMMessage(role: "user", content: text, fileData: fileData)
        let response = try await self.sendMessage(object: message)
        return response?.content ?? ""
    }
    
    public func makeSummary(fromText text: String) async throws -> String {
        let message = GoogleFileLLMMessage(role: "user", content: text, fileData: nil)
        let response = try await self.sendMessage(object: message)
        return response?.content ?? ""
    }
}

extension OpenAILLMClient: SummaryServiceProtocol {
    
    public func makeFileSummary(fromText text: String, data: Data, mimeType: String) async throws -> String {
        guard mimeType == "application/pdf" else {
            throw SummaryClient.SummaryClientError.invalidClient
        }
        
        
        guard let pdfDocument = PDFDocument(data: data) else {
            throw SummaryClient.SummaryClientError.invalidData
        }
        
        var fullText = ""
        for pageIndex in 0..<pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIndex), let pageContent = page.string {
                fullText += pageContent + "\n"
            }
        }
        
        if fullText.isEmpty {
            throw SummaryClient.SummaryClientError.invalidData
        }
        
        let message = LLMMessage(role: "user", content: text.appending(" :") + fullText)
        let response = try await self.sendMessage(object: message)
        return response?.content ?? ""
    }
    
    public func makeSummary(fromText text: String) async throws -> String {
        let message = LLMMessage(role: "user", content: text)
        let response = try await self.sendMessage(object: message)
        return response?.content ?? ""
    }
}
