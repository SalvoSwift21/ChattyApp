//
//  OpenAIConfigurations.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 14/07/23.
//

import Foundation

public class GoogleAIConfigurations {
    //AIzaSyCi9N2rcBGzvt4BAgLIlH2R0qktjUxiGEY
    static public let TEST_API_KEY: String = {
        let base64Value = "QUl6YVN5Q2k5TjJyY0JHenZ0NEJBZ0xJbEgyUjBxa3RqVXhpR0VZ"
        guard let data = Data(base64Encoded: base64Value) else {
            return "Error"
        }
        return String(data: data, encoding: .utf8) ?? "Error"
    }()

    static let ORG_ID = "org-Vf9PkFk6RhkFsVJgasYIXl7j"
    static let BASE_HOST = "api.openai.com"
    static let BASE_PATH = "/v1"
}
