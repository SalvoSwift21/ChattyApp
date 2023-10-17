//
//  OpenAIModels.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 26/07/23.
//

import Foundation
import LLMFeature
import GoogleGenerativeAI

public final class GoogleAIMapper {
    
    public enum GoogleAIMapperError: Error {
        case generic(String)
        case notValidCandidates
        case notValidOutput
    }

    public static func map(_ response: GenerateTextResponse) throws -> GoogleAILLMClient.LLMClientResult {
        
        guard let candidates = response.candidates, let first = candidates.first else {
            throw GoogleAIMapper.GoogleAIMapperError.notValidCandidates
        }
        
        guard let output = first.output else {
            throw GoogleAIMapper.GoogleAIMapperError.notValidOutput
        }
        
        let message = LLMMessage(role: "", content: output)
        
        return message
    }
}
