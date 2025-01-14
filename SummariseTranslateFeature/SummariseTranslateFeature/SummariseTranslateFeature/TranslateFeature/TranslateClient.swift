//
//  TranslateClient.swift
//  SummariseTranslateFeature
//
//  Created by Salvatore Milazzo on 12/06/24.
//

import Foundation
import LLMFeature
import GoogleAIFeature
import OpenAIFeature

public class TranslateClient: TranslateClientProtocol {
    
    
    var translateService: TranslateServiceProtocol
    
    public init(translateService: TranslateServiceProtocol) {
        self.translateService = translateService
    }
    
    public func translate(fromText text: String, to: Locale) async throws -> String {
        let trPrompt = "Translate the following text: \(text) in \(to.identifier)"
        return try await self.translateService.translate(fromText: trPrompt)

    }
    
}

extension GoogleAILLMClient: TranslateServiceProtocol {
    public func translate(fromText text: String) async throws -> String {
        let message = LLMMessage(role: "user", content: text)
        let response = try await self.sendMessage(object: message)
        return response?.content ?? ""
    }
}

extension GoogleAIFileSummizeClient: TranslateServiceProtocol {
    public func translate(fromText text: String) async throws -> String {
        let message = GoogleFileLLMMessage(role: "user", content: text, fileData: DataGenAiThrowingPartsRepresentable(data: Data(), preferredMIMEType: ""))
        let response = try await self.sendMessage(object: message)
        return response?.content ?? ""
    }
}

extension OpenAILLMClient: TranslateServiceProtocol {
    public func translate(fromText text: String) async throws -> String {
        let message = LLMMessage(role: "user", content: text)
        let response = try await self.sendMessage(object: message)
        return response?.content ?? ""
    }
}
