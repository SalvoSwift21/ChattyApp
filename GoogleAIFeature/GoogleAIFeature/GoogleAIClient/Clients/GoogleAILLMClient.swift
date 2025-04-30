//
//  LLMOpenAi.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import Foundation
import RestApi
import LLMFeature
import GoogleGenerativeAI

public class GoogleAILLMClient: LLMClient {
    
   
    public enum GoogleAIError: Error {
        case generic(String)
        case notValidChatResult
    }
    
    public typealias LLMClientResult = LLMMessage?
    public typealias LLMClientObject = GoogleFileLLMMessage
        
    private var history: [LLMMessage] = []

    private var generativeLanguageClient: GenerativeModel
    private var MAX_RESOURCE_TOKEN: Int
    
    public init(generativeLanguageClient: GenerativeModel, maxResourceToken: Int) {
        self.generativeLanguageClient = generativeLanguageClient
        self.MAX_RESOURCE_TOKEN = maxResourceToken
    }

    public func sendMessage(object: GoogleFileLLMMessage) async throws -> LLMMessage? {
        let response = try await handleCorrectResponse(object)
        return try GoogleAIMapper.map(response)
    }
    
    fileprivate func handleCorrectResponse(_ object: GoogleFileLLMMessage) async throws -> GenerateContentResponse {
        let prompt = object.content
        
        guard let fileData = object.fileData else {
            return try await generativeLanguageClient.generateContent(prompt)
        }
        
        let count = try await generativeLanguageClient.countTokens(prompt, fileData)
        
        guard count.totalTokens < MAX_RESOURCE_TOKEN else { throw GoogleAIError.generic("GENERIC_ERROR_DOCUMENT_TO_LARGE_NOT SUPPORTED") }
        
        return try await generativeLanguageClient.generateContent(prompt, fileData)
    }
    
    
    public func saveInHistory(newObject: GoogleFileLLMMessage) async throws {
//        self.history.append(newObject)
    }
    
    public func deleteFromHistory() async throws {
//        self.history.removeAll()
    }
}

public func makeGoogleGeminiAIClient(modelName: String, maxResourceToken: Int) -> GoogleAILLMClient {
    let gl = GenerativeModel(name: modelName, apiKey: GoogleAIConfigurations.API_KEY)
    let sut = GoogleAILLMClient(generativeLanguageClient: gl, maxResourceToken: maxResourceToken)
    return sut
}
