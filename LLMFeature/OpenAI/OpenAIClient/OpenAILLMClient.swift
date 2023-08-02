//
//  LLMOpenAi.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import Foundation
import RestApi

public class OpenAILLMClient: LLMClient {
    
   
    public enum OpenAIError: Error {
        case generic(String)
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
        let messages = createCorrectArrayFromHistory(with: object)
        let result = try await chatCompletetions(for: messages)
        try await saveInHistory(newObject: object, responseText: result?.genericObject)
        return result?.genericObject
    }
    
    public func saveInHistory(newObject: LLMMessage, responseText: LLMMessage?) async throws {
        self.history.append(newObject)
        guard let responseText = responseText else {
            return
        }
        self.history.append(responseText)
    }
    
    public func deleteFromHistory() async throws {
        self.history.removeAll()
    }
    
    
    private func createCorrectArrayFromHistory(with newObject: LLMMessage) -> [LLMMessage] {
        var historyCopy = history
        historyCopy.append(newObject)
        return history.count == 0 ? [newObject] : historyCopy
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
        let endpoint = ChatCompletionEndpoint(messages: messagges, model: "gpt-3.5-turbo", token: configuration.API_KEY)
        let request = try EndpointURLRequestMapper.map(from: endpoint)
        let (data, response) = try await httpClient.makeTaskRequest(from: request).result()
        
        let llmResponse = try OpenAIMapper.map(data, from: response)
        
        return llmResponse
    }
}
