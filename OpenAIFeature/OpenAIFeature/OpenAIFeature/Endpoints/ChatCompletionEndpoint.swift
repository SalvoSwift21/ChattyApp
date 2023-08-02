//
//  ChatCompletionEndpoint.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 18/07/23.
//

import Foundation
import RestApi
import LLMFeature

class ChatCompletionEndpoint: Endpoint {
    
    var scheme: Schema = .HTTPS
    
    var host: String = OpenAiConfiguration.BASE_HOST
    
    var path: String = OpenAiConfiguration.BASE_PATH + "/chat/completions"
    
    var method: RequestMethod = .POST
    
    var query: [String : String]? = nil
    
    var header: [String : String]?
    
    var body: [String : Any]?
        
    init(messages: [LLMMessage], model: String = "gpt-3.5-turbo", token: String = OpenAiConfiguration.TEST_API_KEY) throws {
        let bodyModel = LLMRequestBody(model: model, messages: messages)
        let jsonData = try JSONEncoder().encode(bodyModel)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        
        self.body = jsonObject
        
        self.header = ["Authorization": "Bearer \(token)",
                       "Content-Type": "application/json"]
    }
}
