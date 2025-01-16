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
        let summPrompt = "Summarise the following file"
        return try await summariseService.makeFileSummary(fromText: summPrompt, data: data, mimeType: mimeType)
    }
}

extension GoogleAILLMClient: SummaryServiceProtocol {
    
    public func makeFileSummary(fromText text: String, data: Data, mimeType: String) async throws -> String {
        throw SummaryClient.SummaryClientError.invalidClient
    }
    
    public func makeSummary(fromText text: String) async throws -> String {
        let message = LLMMessage(role: "user", content: text)
        let response = try await self.sendMessage(object: message)
        return response?.content ?? ""
    }
}

extension GoogleAIFileSummizeClient: SummaryServiceProtocol {
    public func makeSummary(fromText text: String) async throws -> String {
        throw SummaryClient.SummaryClientError.invalidClient
    }
    
    public func makeFileSummary(fromText text: String, data: Data, mimeType: String) async throws -> String {
        let fileData = DataGenAiThrowingPartsRepresentable(data: data, preferredMIMEType: mimeType)
        let message = GoogleFileLLMMessage(role: "user", content: text, fileData: fileData)
        let response = try await self.sendMessage(object: message)
        return response?.content ?? ""
    }
    
}

extension OpenAILLMClient: SummaryServiceProtocol {
    
    public func makeFileSummary(fromText text: String, data: Data, mimeType: String) async throws -> String {
        throw SummaryClient.SummaryClientError.invalidClient
    }
    
    public func makeSummary(fromText text: String) async throws -> String {
        let message = LLMMessage(role: "user", content: text)
        let response = try await self.sendMessage(object: message)
        return response?.content ?? ""
    }
}
