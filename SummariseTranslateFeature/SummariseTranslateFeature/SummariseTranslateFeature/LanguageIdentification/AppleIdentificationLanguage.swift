//
//  AppleIdentificationLanguage.swift
//  SummariseTranslateFeature
//
//  Created by Salvatore Milazzo on 07/02/24.
//

import Foundation
import NaturalLanguage

public final class AppleIdentificationLanguage: IdentificationLanguageProtocol {
    
    public enum Error: Swift.Error {
        case invalidLanguage
    }
    
    let recognizer = NLLanguageRecognizer()

    public init() { }
    
    
    public func identifyLanguageProtocol(fromText text: String) throws -> String {
        recognizer.processString(text)
        guard let result = recognizer.dominantLanguage else {
            throw AppleIdentificationLanguage.Error.invalidLanguage
        }
        return result.rawValue
    }
    
}
