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
        
    private var history: [LLMMessage] = []

    private var httpClient: OpenAIApiClient
    
    public init(openAIHTTPClient: OpenAIApiClient) {
        self.httpClient = openAIHTTPClient
    }

    public func sendMessage(object: LLMMessage) async throws -> LLMMessage? {
        
        #warning("Refactor for support first object !!!!!!!!!!!")
        let llmRequestBody: LLMRequestBody = createRequestBody(messages: [object])
        
        guard let result = try await httpClient.chatCompletetions(for: llmRequestBody),
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
    
    private func createRequestBody(messages: [LLMMessage]) -> LLMRequestBody {
        LLMRequestBody(model: "gpt-3.5-turbo", messages: messages, max_tokens: 35, stream: false, temperature: 1.0, user: nil)
    }
}

public func makeOpenAIHTTPClient() -> OpenAILLMClient {
    let session = URLSession(configuration: .default)
    let client = URLSessionHTTPClient(session: session)
    let config = LLMConfiguration(API_KEY: OpenAiConfiguration.TEST_API_KEY, USER_ID: "user")
    let clientOpenAi = OpenAIApiClient(httpClient: client, configuration: config)
    return OpenAILLMClient(openAIHTTPClient: clientOpenAi)
}
