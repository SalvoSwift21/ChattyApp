//
//  LLMOpenAi.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import Foundation
import RestApi

public class OpenAILLMClient: LLMClient {
    
    private var ok: Int = 200
    
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
        try await saveInHistory(newObject: object, responseText: nil)
        let result = try await createChatCompletetions(messagges: history)
        //try await saveInHistory(newObject: object, responseText: result?.genericObject)
        return result?.genericObject
    }
    
    public func saveInHistory(newObject: LLMMessage, responseText: LLMMessage?) async throws {
        self.history.append(newObject)
        guard let responseText = responseText else {
            return
        }
        //self.history = responseText
    }
    
    public func deleteFromHistory() async throws { }
    
  
}

//MARK: Help func for get model
extension OpenAILLMClient {
    
    public func getAiModels() async throws -> [String] {
        let endpoint = GetModelEndpoint(token: configuration.API_KEY)
        let request = try EndpointURLRequestMapper.map(from: endpoint)
        let (data, response) = try await httpClient.makeTaskRequest(from: request).result()
        
        return [""]
    }
    
    private func createChatCompletetions(messagges: [LLMMessage]) async throws -> LLMChatCompletion? {
        let endpoint = ChatCompletionEndpoint(messages: messagges, model: "gpt-3.5-turbo", token: configuration.API_KEY)
        let request = try EndpointURLRequestMapper.map(from: endpoint)
        let (data, response) = try await httpClient.makeTaskRequest(from: request).result()
        
        guard response.statusCode == ok else {
            let errorResponse = try JSONDecoder().decode(ErrorRootResponse.self, from: data)
            throw OpenAIError.generic("Bad Response: \(response.statusCode). \(errorResponse.error)")
        }
        
        let llmResponse = try OpenAIMapper.map(data, from: response)
        
        return llmResponse
    }
}
