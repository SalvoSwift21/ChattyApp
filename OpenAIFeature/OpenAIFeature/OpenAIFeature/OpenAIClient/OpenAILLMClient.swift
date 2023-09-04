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

    private var httpClient: URLSessionHTTPClient
    private var configuration: LLMConfiguration
    
    public init(httpClient: URLSessionHTTPClient, configuration: LLMConfiguration) {
        self.httpClient = httpClient
        self.configuration = configuration
    }

    public func sendMessage(object: LLMMessage) async throws -> LLMMessage? {
        
        guard let result = try await chatCompletetions(for: self.history),
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

//MARK: Help func for get model
extension OpenAILLMClient {
    
    public func getAiModels() async throws -> [String] {
        let endpoint = GetModelEndpoint(token: configuration.API_KEY)
        let request = try EndpointURLRequestMapper.map(from: endpoint)
        let (data, response) = try await httpClient.makeTaskRequest(from: request).result()
        
        return [""]
    }
    
    private func chatCompletetions(for messagges: [LLMMessage]) async throws -> LLMChatCompletion? {
        let endpoint = try ChatCompletionEndpoint(messages: messagges, model: "gpt-3.5-turbo", token: configuration.API_KEY)
        let request = try EndpointURLRequestMapper.map(from: endpoint)
        let (data, response) = try await httpClient.makeTaskRequest(from: request).result()
        
        let llmResponse = try OpenAIMapper.map(data, from: response)
        
        return llmResponse
    }
}
