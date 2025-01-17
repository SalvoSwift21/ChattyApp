//
//  LLMSuppotedLanguages.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 16/01/25.
//

import Foundation


public struct LLMSuppotedLanguages: Codable, Equatable {
    public let languages: [LLMLanguage]
    
    public func getAllLocales() -> [Locale] {
        return languages.map(\.locale)
    }
}

public struct LLMLanguage: Codable, Equatable {
    public let code: String
    public let name: String
    public let locale: Locale
}
