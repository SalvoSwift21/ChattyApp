//
//  LLMClient.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import Foundation

public protocol LLMClient {
    
    associatedtype LLMClientObject
    associatedtype LLMClientResult
    
    @discardableResult
    func sendMessage(object: LLMClientObject) async throws -> LLMClientResult
    
    func saveInHistory(newObject: LLMClientObject, responseText: LLMClientResult) async throws
    func deleteFromHistory() async throws
}
