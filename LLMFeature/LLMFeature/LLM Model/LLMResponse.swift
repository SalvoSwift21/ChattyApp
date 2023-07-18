//
//  LLMResponse.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import Foundation

public struct LLMResponse<T: Codable>: Codable {
    public let totalUsedTokens: Int
    public let genericObject: [T]
    
    public init(totalUsedTokens: Int, genericObject: [T]) {
        self.totalUsedTokens = totalUsedTokens
        self.genericObject = genericObject
    }
}
