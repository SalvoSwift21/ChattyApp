//
//  LLMClient.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import Foundation

public protocol LLMClient {
    
    typealias Result = (String)
    
    @discardableResult
    func sendMessage(text: String) async throws -> LLMClient.Result
    
    func saveInHistory()
    func deleteFromHistory()
}
