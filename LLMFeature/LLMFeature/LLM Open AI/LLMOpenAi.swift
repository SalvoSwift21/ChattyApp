//
//  LLMOpenAi.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import Foundation

class LLMOpenAi: LLMClient {
    
    var configuration: LLMConfiguration
    
    init(configuration: LLMConfiguration) {
        self.configuration = configuration
    }
    
    
    func sendMessage(text: String) async throws -> (String) {
        return ("Test")
    }
    
    func saveInHistory() {
        
    }
    
    func deleteFromHistory() {
        
    }
}
