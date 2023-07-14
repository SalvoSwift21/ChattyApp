//
//  LLMOpenAi.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import Foundation
import LLMFeature
import RestApi

class OpenAILLMClient: LLMClient {
    
    typealias LLMClientResult = String
    
    private var httpClient = URLSessionHTTPClient
    private var configuration = LLMConfiguration
    
    init(httpClient: URLSessionHTTPClient, configuration: LLMConfiguration) {
        self.httpClient = httpClient
        self.configuration = configuration
    }

    public func sendMessage(text: String) async throws -> String {
        return ""
    }
    
    func saveInHistory(userText: String, responseText: String) async throws {
     
    }
    
    
    func deleteFromHistory() async throws {
      
    }
    
  
}
