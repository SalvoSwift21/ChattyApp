//
//  File.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import Foundation

public struct LLMRequestBody {
    public let model: String
    public let messages: [LLMMessage]
    
    public init(model: String, messages: [LLMMessage]) {
        self.messages = messages
        self.model = model
    }
}
