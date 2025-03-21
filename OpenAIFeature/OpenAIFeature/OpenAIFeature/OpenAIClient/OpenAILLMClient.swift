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
    private var openAIModelName: String
    
    private var maxInputToken: Int
    private var maxOutputToken: Int

    public init(openAIHTTPClient: OpenAIApiClient, modelName: String, maxInputToken: Int, maxOutputToken: Int) {
        self.httpClient = openAIHTTPClient
        self.openAIModelName = modelName
        self.maxInputToken = maxInputToken
        self.maxOutputToken = maxOutputToken
    }

    public func sendMessage(object: LLMMessage) async throws -> LLMMessage? {
        
        let count = try await httpClient.getTokenCount(model: openAIModelName, text: object.content)
        
        guard count < maxInputToken else { throw OpenAIError.generic("Document too large") }
        
        let llmRequestBody: LLMRequestBody = createRequestBody(messages: [object], max_tokens: 16384)
        
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
    
    private func createRequestBody(messages: [LLMMessage], max_tokens: Int) -> LLMRequestBody {
        LLMRequestBody(model: openAIModelName, messages: messages, max_output_tokens: maxOutputToken, stream: false, temperature: 1.0, user: nil)
    }
}

public func makeOpenAIHTTPClient(modelName: String, maxInputToken: Int, maxOutputToken: Int) -> OpenAILLMClient {
    let session = URLSession(configuration: .default)
    let client = URLSessionHTTPClient(session: session)
    let config = LLMConfiguration(API_KEY: OpenAiConfiguration.TEST_API_KEY, USER_ID: "user")
    let clientOpenAi = OpenAIApiClient(httpClient: client, configuration: config)
    return OpenAILLMClient(openAIHTTPClient: clientOpenAi, modelName: modelName, maxInputToken: maxInputToken, maxOutputToken: maxOutputToken)
}
