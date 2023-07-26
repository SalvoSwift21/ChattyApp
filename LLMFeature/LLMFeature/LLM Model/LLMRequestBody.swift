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
    public var user: String = "testUser"
    
    public init(model: String, messages: [LLMMessage]) {
        self.messages = messages
        self.model = model
    }
}
