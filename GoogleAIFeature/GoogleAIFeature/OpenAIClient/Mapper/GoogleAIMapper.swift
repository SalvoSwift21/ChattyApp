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

/// Every response will include a finish_reason. The possible values for finish_reason are:
///
///stop: API returned complete message, or a message terminated by one of the stop sequences provided via the stop parameter
///length: Incomplete model output due to max_tokens parameter or token limit
///function_call: The model decided to call a function
///content_filter: Omitted content due to a flag from our content filters
///null: API response still in progress or incomplete
///
///info for this data https://platform.openai.com/docs/guides/gpt/chat-completions-api
public enum FinishReason: String, Codable {
    case stop, length, function_call, content_filter
}

public struct StreamChoice: Codable {
    public let delta: Delta
    let finish_reason: FinishReason?
}

public struct Delta: Codable {
    public let content: String?
}

public enum OpenAIMapperError: Error {
    case invalidResponseCode(String)
    case invalidResponse
}

public final class OpenAICompletionMapper {
    private struct Root: Decodable {
        
        let choices: [Choice]
        let usage: Usage?
        
        var llmChatCompletion: OpenAIApiClient.LLMChatCompletion {
            OpenAIApiClient.LLMChatCompletion(totalUsedTokens: usage?.total_tokens ?? 0, genericObject: choices.first?.message)
        }
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> OpenAIApiClient.LLMChatCompletion {
        guard response.isOK else {
            let errorResponse = try JSONDecoder().decode(ErrorRootResponse.self, from: data)
            throw OpenAIMapperError.invalidResponseCode("Bad Response: \(response.statusCode). \(errorResponse.error)")
        }
        
        let root = try JSONDecoder().decode(Root.self, from: data)
        
        return root.llmChatCompletion
    }
}


public final class OpenAIStreamCompletionMapper {
    private struct Root: Decodable {
        let choices: [StreamChoice]
        let usage: Usage?
    }
    
    public static func map(_ asyncBytes: URLSession.AsyncBytes, from response: HTTPURLResponse) async throws -> AsyncThrowingStream<OpenAIApiClient.Status, Error> {
        
        guard response.isOK else {
            var data = Data()
            for try await buffer in asyncBytes {
                try Task.checkCancellation()
                data.append(.init(buffer))
            }
            
            if data.count > 0, let errorResponse = try? JSONDecoder().decode(ErrorRootResponse.self, from: data).error {
                
                throw OpenAIMapperError.invalidResponseCode("Bad Response: \(response.statusCode). \(errorResponse.message)")
            }
            
            throw OpenAIMapperError.invalidResponse
        }
        
        return getDataFrom(asyncBytes)
    }
    
    fileprivate static func getDataFrom(_ asyncBytes: URLSession.AsyncBytes) -> AsyncThrowingStream<OpenAIApiClient.Status, Error> {
        var responseText = ""
        return AsyncThrowingStream<OpenAIApiClient.Status, Error> {
            
            for try await buffer in asyncBytes.lines {
                try Task.checkCancellation()
                let line = String(buffer)
                
                guard line.hasPrefix("data: "),
                      let data = line.dropFirst(6).data(using: .utf8) else {
                    return .error(throwing: OpenAIMapperError.invalidResponse)
                }
                
                let response = try JSONDecoder().decode(Root.self, from: data)
                
                guard let finishReason = response.choices.first?.finish_reason else {
                    guard let text = response.choices.first?.delta.content else {
                        return .error(throwing: OpenAIMapperError.invalidResponse)
                    }
                    
                    responseText += text
                    return .stream(text)
                }
                
                switch finishReason {
                case .content_filter, .function_call, .length, .stop:
                    return .finished(responseText)
                }
            }
            
            return nil
        }
    }
}
