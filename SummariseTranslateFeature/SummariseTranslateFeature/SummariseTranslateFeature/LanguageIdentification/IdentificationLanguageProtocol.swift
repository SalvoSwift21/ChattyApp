//
//  LanguageIdentificationProtocol.swift
//  SummariseTranslateFeature
//
//  Created by Salvatore Milazzo on 07/02/24.
//

import Foundation

public protocol IdentificationLanguageProtocol {
    func identifyLanguage(fromText text: String) throws -> String
}
