//
//  OpenAIConfigurations.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 14/07/23.
//

import Foundation
import UniformTypeIdentifiers

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

public class GoogleAIConfigurations {
    //AIzaSyCi9N2rcBGzvt4BAgLIlH2R0qktjUxiGEY
    static public let TEST_API_KEY: String = {
        let base64Value = "QUl6YVN5Q2k5TjJyY0JHenZ0NEJBZ0xJbEgyUjBxa3RqVXhpR0VZ"
        guard let data = Data(base64Encoded: base64Value) else {
            return "Error"
        }
        return String(data: data, encoding: .utf8) ?? "Error"
    }()
    
    func getSupportedUTType() -> [UTType] {
        [.pdf, .javaScript, .text, .html, .css, .commaSeparatedText, .xml, .rtf]
    }
}
