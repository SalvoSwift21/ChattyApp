//
//  PostNumberOfToken.swift
//  OpenAIFeature
//
//  Created by Salvatore Milazzo on 3/21/25.
//

import Foundation
import RestApi
import LLMFeature

class PostNumberOfToken: Endpoint {
    
    var scheme: Schema = .HTTPS
 
    var host: String = "counttokens-ulnfu45kta-uc.a.run.app"
    
    var path: String = ""
    
    var method: RequestMethod = .POST
    
    var query: [String : String]? = nil
    
    var header: [String : String]?
    
    var body: [String : Any]?
        
    init(model: String, text: String) throws {
        let requestBody: [String: Any] = ["model": model, "text": text]
        self.body = requestBody
        self.header = ["Content-Type": "application/json"]
    }
}
