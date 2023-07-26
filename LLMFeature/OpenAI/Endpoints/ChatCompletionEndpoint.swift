//
//  ChatCompletionEndpoint.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 18/07/23.
//

import Foundation
import RestApi

class ChatCompletionEndpoint: Endpoint {
    
    var scheme: Schema = .HTTPS
    
    var host: String = OpenAiConfiguration.BASE_HOST
    
    var path: String = OpenAiConfiguration.BASE_PATH + "/chat/completions"
    
    var method: RequestMethod = .POST
    
    var query: [String : String]? = nil
    
    var header: [String : String]?
    
    var body: Encodable? = nil
    
    init(messages: [LLMMessage], model: String = "gpt-3.5-turbo", token: String = OpenAiConfiguration.TEST_API_KEY) {
        self.body = LLMRequestBody(model: model, messages: messages)
        
        self.header = ["Authorization": "Bearer \(token)",
                       "Content-Type": "application/json"]
    }
}
