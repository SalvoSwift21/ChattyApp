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
    
    var header: [String : String]? = OpenAiConfiguration.BASE_AUTH_HEADER
    
    var body: [String : Any]? = nil
    
    init(messages: [LLMMessage], model: String = "gpt-3.5-turbo") {
        self.body = [:]
        self.body?["message"] = messages
        self.body?["model"] = model
        self.body?["temperature"] = 1.0
        self.body?["stream"] = false
        self.body?["max_tokens"] = 20.0
        self.body?["user"] = "testUser"
    }
}
