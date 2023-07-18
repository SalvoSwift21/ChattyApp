//
//  GetModelDetailEndpoint.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 18/07/23.
//

import Foundation
import RestApi

class GetModelDetailEndpoint: Endpoint {
    
    private let modelName: String
    
    var scheme: Schema = .HTTPS
    
    var host: String = OpenAiConfiguration.BASE_HOST
    
    var path: String = OpenAiConfiguration.BASE_PATH + "/models/"
    
    var method: RequestMethod = .GET
    
    var query: [String : String]? = nil
    
    var header: [String : String]? = OpenAiConfiguration.BASE_AUTH_HEADER
    
    var body: [String : Any]? = nil
    
    init(modelName: String) {
        self.modelName = modelName
        self.path += modelName
    }
}
