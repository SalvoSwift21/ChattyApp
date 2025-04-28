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
        let summPrompt = """
        Summarize the following text focusing on the main ideas, arguments, and conclusions. \
        Write a coherent and natural summary in paragraph form. Avoid missing critical information. \
        Only output the final summarized text.
        Text: \(text)
        """
        return try await self.summariseService.makeSummary(fromText: summPrompt)
    }
    
    public func makeSummary(forData data: Data, mimeType: String) async throws -> String {
        let summPrompt = """
            Analyze and summarize the following document. Focus on capturing key ideas, main arguments, and important conclusions. \
            Structure the summary in a clear and readable format, using paragraphs or bullet points depending on the document's complexity. \
            Be concise but do not omit essential information. Only output the final summarized text.
            """
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
