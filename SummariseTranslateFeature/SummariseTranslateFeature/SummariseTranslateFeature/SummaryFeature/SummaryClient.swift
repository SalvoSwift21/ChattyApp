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
    
    var summariseService: SummaryServiceProtocol
    
    public init(summariseService: SummaryServiceProtocol) {
        self.summariseService = summariseService
    }
    
    public func makeSummary(fromText text: String) async throws -> String {
        let summPrompt = "Summarise the following text: \(text)"
        return try await self.summariseService.makeSummary(fromText: summPrompt)

    }
}

extension GoogleAILLMClient: SummaryServiceProtocol {
    public func makeSummary(fromText text: String) async throws -> String {
        let message = LLMMessage(role: "user", content: text)
        let response = try await self.sendMessage(object: message)
        return response?.content ?? ""
    }
}

extension OpenAILLMClient: SummaryServiceProtocol {
    public func makeSummary(fromText text: String) async throws -> String {
        let message = LLMMessage(role: "user", content: text)
        let response = try await self.sendMessage(object: message)
        return response?.content ?? ""
    }
}
