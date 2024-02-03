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

    public static func map(_ response: GenerateContentResponse) throws -> GoogleAILLMClient.LLMClientResult {
        
        guard let text = response.text else {
            throw GoogleAIMapper.GoogleAIMapperError.notValidOutput
        }
        
        let message = LLMMessage(role: "", content: text)
        
        return message
    }
}
