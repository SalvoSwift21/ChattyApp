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
    public let fileData: DataGenAiThrowingPartsRepresentable
    
    public init(role: String, content: String, fileData: DataGenAiThrowingPartsRepresentable) {
        self.role = role
        self.content = content
        self.fileData = fileData
    }
}
