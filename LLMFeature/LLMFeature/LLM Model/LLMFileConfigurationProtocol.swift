//
//  LLMFileConfigurationProtocol.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 11/12/24.
//


import Foundation
import UniformTypeIdentifiers


public protocol LLMFileConfigurationProtocol {
    static var TEST_API_KEY: String { get }
    static var ORG_ID: String { get }
    static var BASE_HOST: String { get }
    static var BASE_PATH: String { get }
    
    static func getSupportedUTType() -> [UTType]
    static func getSupportedLanguages() throws -> LLMSuppotedLanguages
}
