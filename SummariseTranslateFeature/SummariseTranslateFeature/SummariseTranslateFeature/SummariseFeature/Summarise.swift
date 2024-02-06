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

public class Summarise {

    var llmclient: SummariseProtocol
    
    public init(llmclient: SummariseProtocol) {
        self.llmclient = llmclient
    }
    
    public func summerizee(fromText text: String) async throws -> String {
        let summPrompt = "Summarise the following text: \(text)"
        return try await self.llmclient.summurize(fromText: summPrompt)
    }
}

extension GoogleAILLMClient: SummariseProtocol {
    public func summurize(fromText text: String) async throws -> String {
        let message = LLMMessage(role: "user", content: text)
        let response = try await self.sendMessage(object: message)
        return response?.content ?? ""
    }
}

extension OpenAILLMClient: SummariseProtocol {
    public func summurize(fromText text: String) async throws -> String {
        let message = LLMMessage(role: "user", content: text)
        let response = try await self.sendMessage(object: message)
        return response?.content ?? ""
    }
}
