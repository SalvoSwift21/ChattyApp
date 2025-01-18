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
    var localeToTranslate: Locale
    
    public init(translateService: TranslateServiceProtocol, localeToTranslate: Locale) {
        self.translateService = translateService
        self.localeToTranslate = localeToTranslate
    }
    
    public func translate(fromText text: String) async throws -> String {
        let trPrompt = "Translate the following text: \(text) in \(localeToTranslate.identifier)"
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
