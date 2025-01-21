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
    
    enum Error: Swift.Error {
        case unableToTranslate
        case languageIsTheSame
    }
    
    var translateService: TranslateServiceProtocol
    var identificationLanguageClient: IdentificationLanguageProtocol
    var localeToTranslate: Locale
    
    public init(translateService: TranslateServiceProtocol,
                identificationLanguageClient: IdentificationLanguageProtocol,
                localeToTranslate: Locale) {
        self.translateService = translateService
        self.localeToTranslate = localeToTranslate
        self.identificationLanguageClient = identificationLanguageClient
    }
    
    public func translate(fromText text: String) async throws -> String {
        
        let currentLanguage = try self.identificationLanguageClient.identifyLanguage(fromText: text)
        
        guard currentLanguage != localeToTranslate.identifier else { throw TranslateClient.Error.languageIsTheSame }
        
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
        let message = GoogleFileLLMMessage(role: "user", content: text, fileData: nil)
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
