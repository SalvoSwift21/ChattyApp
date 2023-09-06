//
//  OpenAIHTTPClient.swift
//  OpenAIFeature
//
//  Created by Salvatore Milazzo on 04/09/23.
//

import Foundation
import RestApi
import LLMFeature

public class OpenAIApiClient {
    
    public typealias LLMChatCompletion = LLMResponse<LLMMessage?>
    
    private var httpClient: URLSessionHTTPClient
    private var configuration: LLMConfiguration

    public init(httpClient: URLSessionHTTPClient, configuration: LLMConfiguration) {
        self.httpClient = httpClient
        self.configuration = configuration
    }
    
    public func getAIModels() async throws -> [OpenAIModel] {
        let endpoint = GetModelEndpoint(token: configuration.API_KEY)
        let request = try EndpointURLRequestMapper.map(from: endpoint)
        let (data, response) = try await httpClient.makeTaskRequest(from: request).result()
        let modelResponse = try OpenAIModelsMapper.map(data, from: response)
        return modelResponse
    }
    
    public func chatCompletetions(for requestBody: LLMRequestBody) async throws -> LLMChatCompletion? {
        let endpoint = try ChatCompletionEndpoint(llmRequestBody: requestBody, token: configuration.API_KEY)
        let request = try EndpointURLRequestMapper.map(from: endpoint)
        let (data, response) = try await httpClient.makeTaskRequest(from: request).result()
        
        let llmResponse = try OpenAICompletionMapper.map(data, from: response)
        
        return llmResponse
    }
}
