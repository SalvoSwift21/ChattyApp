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
    
    public enum Status {
        case stream(String)
        case finished(String)
        case error(throwing: Error)
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
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
}

extension OpenAIApiClient {
    
    public func chatCompletetions(for requestBody: LLMRequestBody) async throws -> LLMChatCompletion? {
        let endpoint = try ChatCompletionEndpoint(llmRequestBody: requestBody, token: configuration.API_KEY)
        let request = try EndpointURLRequestMapper.map(from: endpoint)
        let (data, response) = try await httpClient.makeTaskRequest(from: request).result()
        return try OpenAICompletionMapper.map(data, from: response)
    }

    
    public func chatCompletetionsStream(for requestBody: LLMRequestBody) async throws -> AsyncThrowingStream<Status, Error> {
        
        let endpoint = try ChatCompletionEndpoint(llmRequestBody: requestBody, token: configuration.API_KEY)
        let request = try EndpointURLRequestMapper.map(from: endpoint)
        let (data, response) = try await httpClient.makeStreamTaskRequest(from: request).result()
        return try await OpenAIStreamCompletionMapper.map(data, from: response)
    }
    
    public func getToken(model: String, text: String) async throws -> Int {
        let endpoint = try PostNumberOfToken(model: model, text: text)
        let request = try EndpointURLRequestMapper.map(from: endpoint)
        let (data, response) = try await httpClient.makeTaskRequest(from: request).result()
        return try OpenAITokenMapper.map(data, from: response).tokenCount
    }
}
