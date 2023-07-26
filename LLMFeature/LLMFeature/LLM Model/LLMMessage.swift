//
//  LLMMessage.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import Foundation

public struct LLMMessage: Codable {
    public let role: String
    public let content: String
    
    public init(role: String, content: String) {
        self.role = role
        self.content = content
    }
}
