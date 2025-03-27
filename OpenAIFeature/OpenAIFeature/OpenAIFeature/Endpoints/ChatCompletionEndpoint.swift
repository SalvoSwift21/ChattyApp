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
        
    init(llmRequestBody: LLMRequestBody, token: String = OpenAiConfiguration.TEST_API_KEY) throws {
                
        let jsonData = try JSONEncoder().encode(llmRequestBody)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        
        self.body = jsonObject
        
        self.header = ["Authorization": "Bearer \(token)",
                       "Content-Type": "application/json"]
    }
}
