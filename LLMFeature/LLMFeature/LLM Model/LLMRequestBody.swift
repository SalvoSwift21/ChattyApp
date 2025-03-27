//
//  File.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import Foundation

public struct LLMRequestBody: Codable {
    
    public let model: String
    public let messages: [LLMMessage]
    public var max_tokens: Int = 25
    public var stream: Bool = false
    public var temperature: Double = 1.0
    public var user: String?
    
    public init(model: String, messages: [LLMMessage], max_output_tokens: Int = 25, stream: Bool = false, temperature: Double = 1.0, user: String? = nil) {
        self.model = model
        self.messages = messages
        self.max_tokens = max_output_tokens
        self.stream = stream
        self.temperature = temperature
        self.user = user
    }
}
