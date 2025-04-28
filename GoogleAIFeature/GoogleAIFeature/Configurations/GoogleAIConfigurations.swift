//
//  OpenAIConfigurations.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 14/07/23.
//

import Foundation
import UniformTypeIdentifiers
import LLMFeature

//# File extensions supported by Google AI
//PDF - application/pdf
//JavaScript - application/x-javascript, text/javascript
//Python - application/x-python, text/x-python
//TXT - text/plain
//HTML - text/html
//CSS - text/css
//Markdown - text/md
//CSV - text/csv
//XML - text/xml
//RTF - text/rtf

public class GoogleAIConfigurations: LLMFileConfigurationProtocol {
    
    enum GoogleAIError: Error {
        case JSONNotFound
        case JSONNotValid
    }
    
    public static var ORG_ID: String = ""
    
    public static var BASE_HOST: String = ""
    
    public static var BASE_PATH: String = ""
    
    static public let TEST_API_KEY: String = {
        let base64Value = "QUl6YVN5Qi1aQWpmTXdjQm9ES0p1NGxpZTlsaGZrZkVGbEFlTWhn"
        guard let data = Data(base64Encoded: base64Value) else {
            return "Error"
        }
        return String(data: data, encoding: .utf8) ?? "Error"
    }()
    
    public static func getSupportedUTType() -> [UTType] {
        [.image, .png, .jpeg, .pdf, .text, .html, .css, .commaSeparatedText, .xml, .rtf]
    }
    
    public static func getSupportedLanguages() throws -> LLMSuppotedLanguages {
        let localBundle = Bundle(identifier: "com.ariel.GoogleAIFeature") ?? .main

        guard let resourceUrl = localBundle.url(forResource: "languages", withExtension: ".json") else {
            throw GoogleAIError.JSONNotFound
        }
        
        
        guard let data = try? Data(contentsOf: resourceUrl) else {
            throw GoogleAIError.JSONNotValid
        }
        
        return try JSONDecoder().decode(LLMSuppotedLanguages.self, from: data)
    }
}
