//
//  OpenAIModels.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 26/07/23.
//

import Foundation
import LLMFeature

struct ErrorRootResponse: Decodable {
    let error: ErrorResponse
}

struct ErrorResponse: Decodable {
    let message: String
    let type: String?
}

struct Usage: Decodable {
    let prompt_tokens: Int?
    let completion_tokens: Int?
    let total_tokens: Int?
}

public struct Choice: Codable {
    let finish_reason: String?
    public let message: LLMMessage
    
    public init(finish_reason: String? = nil, message: LLMMessage) {
        self.finish_reason = finish_reason
        self.message = message
    }
}


public final class OpenAICompletionMapper {
    private struct Root: Decodable {
        
        let choices: [Choice]
        let usage: Usage?
        
        var llmChatCompletion: OpenAILLMClient.LLMChatCompletion {
            OpenAILLMClient.LLMChatCompletion(totalUsedTokens: usage?.total_tokens ?? 0, genericObject: choices.first?.message)
        }
    }
    
    public enum OpenAIMapperError: Error {
        case invalidResponseCode(String)
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> OpenAILLMClient.LLMChatCompletion {
        guard response.isOK else {
            let errorResponse = try JSONDecoder().decode(ErrorRootResponse.self, from: data)
            throw OpenAIMapperError.invalidResponseCode("Bad Response: \(response.statusCode). \(errorResponse.error)")
        }
        
        let root = try JSONDecoder().decode(Root.self, from: data)
        
        return root.llmChatCompletion
    }
}
