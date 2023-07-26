//
//  OpenAIModels.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 26/07/23.
//

import Foundation

public final class OpenAIMapper {
    private struct Root: Decodable {
        
        private var completionResponse: CompletionResponse
        
        private struct CompletionResponse: Decodable {
            let choices: [Choice]
            let usage: Usage?
        }
        
        var llmChatCompletion: OpenAILLMClient.LLMChatCompletion {
            OpenAILLMClient.LLMChatCompletion(totalUsedTokens: completionResponse.usage?.totalTokens ?? 0, genericObject: completionResponse.choices.first?.message)
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> OpenAILLMClient.LLMChatCompletion {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        return root.llmChatCompletion
    }
}


struct ErrorRootResponse: Decodable {
    let error: ErrorResponse
}

struct ErrorResponse: Decodable {
    let message: String
    let type: String?
}

struct Usage: Decodable {
    let promptTokens: Int?
    let completionTokens: Int?
    let totalTokens: Int?
}

struct Choice: Decodable {
    let finishReason: String?
    let message: LLMMessage
}
