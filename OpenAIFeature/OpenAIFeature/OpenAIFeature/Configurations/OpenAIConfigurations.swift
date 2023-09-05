//
//  OpenAIConfigurations.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 14/07/23.
//

import Foundation

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

public class OpenAiConfiguration {
    static public let TEST_API_KEY = "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"
    static let ORG_ID = "org-Vf9PkFk6RhkFsVJgasYIXl7j"
    static let BASE_HOST = "api.openai.com"
    static let BASE_PATH = "/v1"
}
