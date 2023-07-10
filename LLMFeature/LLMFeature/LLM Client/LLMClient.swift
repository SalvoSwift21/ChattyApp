//
//  LLMClient.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import Foundation

public protocol LLMClient {
    
    associatedtype LLMClientResult
    
    @discardableResult
    func sendMessage(text: String) async throws -> LLMClientResult
    
    func saveInHistory(userText: String, responseText: LLMClientResult) async throws
    func deleteFromHistory() async throws
}
