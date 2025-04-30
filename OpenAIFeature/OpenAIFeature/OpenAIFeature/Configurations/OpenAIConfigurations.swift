//
//  OpenAIConfigurations.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 14/07/23.
//

import Foundation
import UniformTypeIdentifiers
import LLMFeature

/*
ROLE
system, user, assistant, or function
 

ENDPOINT    MODEL NAME
/v1/chat/completions        gpt-4, gpt-4-0613, gpt-4-32k, gpt-4-32k-0613, gpt-3.5-turbo,
                            gpt-3.5-turbo-0613, gpt-3.5-turbo-16k, gpt-3.5-turbo-16k-0613
/v1/completions (Legacy)    text-davinci-003, text-davinci-002, text-davinci-001, text-curie-001,                                  text-babbage-001, text-ada-001, davinci, curie, babbage, ada
/v1/audio/transcriptions    whisper-1
/v1/audio/translations      whisper-1
/v1/fine-tunes              davinci, curie, babbage, ada
/v1/embeddings              text-embedding-ada-002, text-similarity-*-001, text-search-*-*-001,                                    code-search-*-*-001
/v1/moderations             text-moderation-stable, text-moderation-latest
*/


public class OpenAiConfiguration: LLMFileConfigurationProtocol {
    
    enum OpenAIError: Error {
        case JSONNotFound
        case JSONNotValid
    }
    
    
    static public let API_KEY: String = {
        let base64Value = "c2stcHJvai1oWkJLdDZaYzgzbDNoU0hadm94TGo4MXM2ZzZGamx0RkFvNkxBbko2MXhSNk1IUGtrTkNQUlRWZkJ3eFpjbnJDNVdOMFRJbzktTFQzQmxia0ZKQ08wcWY3ODZ3ekRPZktNRjNtSGpCSnU4bXNwRkp6a0Zrc1VNWE9KRFFWTVRMU0JrblFEb2NZcFJHYXo2dGJSekx1NEhpbk5lQUE="
        guard let data = Data(base64Encoded: base64Value) else {
            return "Error"
        }
        return String(data: data, encoding: .utf8) ?? "Error"
    }()

    public static let ORG_ID = ""
    public static let BASE_HOST = "api.openai.com"
    public static let BASE_PATH = "/v1"
    
    public static func getSupportedUTType() -> [UTType] {
        [.image, .png, .jpeg, .pdf]
    }
    
    public static func getSupportedLanguages() throws -> LLMSuppotedLanguages {
        let localBundle = Bundle(identifier: "com.ariel.OpenAIFeature") ?? .main
        
        guard let resourceUrl = localBundle.url(forResource: "languages", withExtension: ".json") else {
            throw OpenAIError.JSONNotFound
        }
        
        guard let data = try? Data(contentsOf: resourceUrl) else {
            throw OpenAIError.JSONNotValid
        }
        
        let model = try JSONDecoder().decode(LLMSuppotedLanguages.self, from: data)
        
        return model
    }
}
