//
//  LLMOpenAi.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import Foundation
import RestApi

public class OpenAILLMClient: LLMClient {
    
    
    public typealias LLMClientResult = [LLMMessage]
    
    private typealias LLMChatCompletion = LLMResponse<LLMMessage>
    
    private var httpClient: URLSessionHTTPClient
    private var configuration: LLMConfiguration
    
    public init(httpClient: URLSessionHTTPClient, configuration: LLMConfiguration) {
        self.httpClient = httpClient
        self.configuration = configuration
    }

    public func sendMessage(text: String) async throws -> [LLMMessage] {
        let userNewMessage = LLMMessage(role: "user", content: text)
        return try await createChatCompletetions(messagges: [userNewMessage])?.genericObject ?? []
    }
    
    public func saveInHistory(userText: String, responseText: [LLMMessage]) async throws {
    }
    
    public func deleteFromHistory() async throws { }
    
  
}

//MARK: Help func for get model
extension OpenAILLMClient {
    
    public func getAiModels() async throws -> [String] {
        let endpoint = GetModelEndpoint()
        let request = try EndpointURLRequestMapper.map(from: endpoint)
        let (data, response) = try await httpClient.makeTaskRequest(from: request).result()
        
        return [""]
    }
    
    private func createChatCompletetions(messagges: [LLMMessage]) async throws -> LLMChatCompletion? {
        let endpoint = ChatCompletionEndpoint(messages: messagges)
        let request = try EndpointURLRequestMapper.map(from: endpoint)
        let (data, _) = try await httpClient.makeTaskRequest(from: request).result()
        
        let llmResponse = try JSONDecoder().decode(LLMChatCompletion.self, from: data)
        
        return llmResponse
    }
}
