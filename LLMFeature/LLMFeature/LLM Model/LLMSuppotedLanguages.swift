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
    
    public var id: UUID

    public let code: String
    public let name: String
    public let locale: Locale
    
    public init(code: String, name: String, locale: Locale, id: UUID) {
        self.code = code
        self.name = name
        self.locale = locale
        self.id = id
    }
    
    enum CodingKeys: CodingKey {
        case code
        case name
        case locale
        case id
    }
    
    // Decodifica manuale per trasformare la stringa in un oggetto Locale
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let localeIdentifier = try container.decode(String.self, forKey: .locale)
        self.locale = Locale(identifier: localeIdentifier)
        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decode(String.self, forKey: .name)
        do {
            self.id = try container.decode(UUID.self, forKey: .id)
        } catch {
            self.id = UUID()
        }
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.code, forKey: .code)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.locale.identifier, forKey: .locale)
        try container.encode(self.id, forKey: .id)
    }
}
