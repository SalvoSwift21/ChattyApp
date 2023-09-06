//
//  LLMOpenAi.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import Foundation
import RestApi
import LLMFeature

public class OpenAILLMClient: LLMClient {
   
    public enum OpenAIError: Error {
        case generic(String)
        case notValidChatCompletetionsResult
    }
    
    public typealias LLMClientResult = LLMMessage?
    public typealias LLMClientObject = LLMMessage
    
    public typealias LLMChatCompletion = LLMResponse<LLMMessage?>
    
    private var history: [LLMMessage] = []

    private var httpClient: OpenAIApiClient
    
    public init(openAIHTTPClient: OpenAIApiClient) {
        self.httpClient = openAIHTTPClient
    }

    public func sendMessage(object: LLMMessage) async throws -> LLMMessage? {
        
        guard let result = try await httpClient.chatCompletetions(for: self.history),
                let message = result.genericObject else {
            throw OpenAIError.notValidChatCompletetionsResult
        }
        
        try await saveInHistory(newObject: object)
        try await saveInHistory(newObject: message)
        return result.genericObject
    }
    
    public func saveInHistory(newObject: LLMMessage) async throws {
        self.history.append(newObject)
    }
    
    public func deleteFromHistory() async throws {
        self.history.removeAll()
    }
}
