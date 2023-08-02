//
//  GetModelsEndpoint.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 18/07/23.
//

import Foundation
import RestApi

class GetModelEndpoint: Endpoint {
    var scheme: Schema = .HTTPS
    
    var host: String = OpenAiConfiguration.BASE_HOST
    
    var path: String = OpenAiConfiguration.BASE_PATH + "/models"
    
    var method: RequestMethod = .GET
    
    var query: [String : String]? = nil
    
    var header: [String : String]?
    
    var body: [String : Any]? = nil
    
    init(token: String = OpenAiConfiguration.TEST_API_KEY) {
        self.header = ["Authorization": "Bearer \(token)"]
    }
}
