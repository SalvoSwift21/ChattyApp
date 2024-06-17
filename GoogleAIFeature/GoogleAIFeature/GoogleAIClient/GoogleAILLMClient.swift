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
    public typealias LLMClientObject = LLMMessage
        
    private var history: [LLMMessage] = []

    private var generativeLanguageClient: GenerativeModel
    
    public init(generativeLanguageClient: GenerativeModel) {
        self.generativeLanguageClient = generativeLanguageClient
    }

    public func sendMessage(object: LLMMessage) async throws -> LLMMessage? {
        
        let prompt = object.content
        let response = try await generativeLanguageClient.generateContent(prompt)
        
        guard let message = try GoogleAIMapper.map(response) else { throw GoogleAIError.notValidChatResult }
        
        try await saveInHistory(newObject: object)
        try await saveInHistory(newObject: message)
        
        return message
    }
    
    public func saveInHistory(newObject: LLMMessage) async throws {
        self.history.append(newObject)
    }
    
    public func deleteFromHistory() async throws {
        self.history.removeAll()
    }
}

public func makeGoogleGeminiProAIClient() -> GoogleAILLMClient {
    let gl = GenerativeModel(name: "gemini-pro", apiKey: GoogleAIConfigurations.TEST_API_KEY)
    let sut = GoogleAILLMClient(generativeLanguageClient: gl)
    return sut
}

public func makeGoogleGeminiFlashAIClient() -> GoogleAILLMClient {
    let gl = GenerativeModel(name: "gemini-1.5-flash", apiKey: GoogleAIConfigurations.TEST_API_KEY)
    let sut = GoogleAILLMClient(generativeLanguageClient: gl)
    return sut
}
