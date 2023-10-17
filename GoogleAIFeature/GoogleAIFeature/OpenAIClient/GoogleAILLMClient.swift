//
//  LLMOpenAi.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import Foundation
import RestApi
import LLMFeature

public class GoogleAILLMClient: LLMClient {
   
    public enum OpenAIError: Error {
        case generic(String)
        case notValidChatCompletetionsResult
    }
    
    public typealias LLMClientResult = LLMMessage?
    public typealias LLMClientObject = LLMMessage
        
    private var history: [LLMMessage] = []

    private var httpClient: String
    
    public init(openAIHTTPClient: String) {
        self.httpClient = openAIHTTPClient
    }

    public func sendMessage(object: LLMMessage) async throws -> LLMMessage? {
        return nil
    }
    
    public func saveInHistory(newObject: LLMMessage) async throws {
        self.history.append(newObject)
    }
    
    public func deleteFromHistory() async throws {
        self.history.removeAll()
    }
}
