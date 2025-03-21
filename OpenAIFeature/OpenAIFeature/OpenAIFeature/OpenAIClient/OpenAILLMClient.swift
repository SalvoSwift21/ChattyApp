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
    
    private var MAX_RESOURCES_TOKEN: Int

    public init(openAIHTTPClient: OpenAIApiClient, modelName: String, maxResourceToken: Int) {
        self.httpClient = openAIHTTPClient
        self.openAIModelName = modelName
        self.MAX_RESOURCES_TOKEN = maxResourceToken
    }

    public func sendMessage(object: LLMMessage) async throws -> LLMMessage? {
        
        let count = try await httpClient.getToken(model: openAIModelName, text: object.content)
        
        guard count < MAX_RESOURCES_TOKEN else { throw OpenAIError.generic("Document too large") }
        
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
        LLMRequestBody(model: openAIModelName, messages: messages, max_tokens: max_tokens, stream: false, temperature: 1.0, user: nil)
    }
}

public func makeOpenAIHTTPClient(modelName: String, maxResourceToken: Int) -> OpenAILLMClient {
    let session = URLSession(configuration: .default)
    let client = URLSessionHTTPClient(session: session)
    let config = LLMConfiguration(API_KEY: OpenAiConfiguration.TEST_API_KEY, USER_ID: "user")
    let clientOpenAi = OpenAIApiClient(httpClient: client, configuration: config)
    return OpenAILLMClient(openAIHTTPClient: clientOpenAi, modelName: modelName, maxResourceToken: maxResourceToken)
}
