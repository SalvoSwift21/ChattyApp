//
//  GoogleFileLLMMessage.swift
//  GoogleAIFeature
//
//  Created by Salvatore Milazzo on 10/12/24.
//

import Foundation

public struct GoogleFileLLMMessage: Codable, Equatable {
    public let role: String
    public let content: String
    public let fileURL: URL
    
    public init(role: String, content: String, fileURL: URL) {
        self.role = role
        self.content = content
        self.fileURL = fileURL
    }
}
