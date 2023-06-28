//
//  EndpointStub.swift
//  RestApiTests
//
//  Created by Salvatore Milazzo on 26/06/23.
//

import Foundation
import RestApi

class EndpointStub: Endpoint {
    
    var scheme: RestApi.Schema {
        .HTTP
    }
    
    var host: String
    
    var path: String
    
    var method: RestApi.RequestMethod {
        .GET
    }
    
    var query: [String : String]? {
        ["limit": "10"]
    }
    
    var header: [String : String]? {
        ["Auth": "Test token"]
    }
    
    var body: [String : Any]?
    
    init(host: String, path: String = "/v1/try", body: [String : Any]? = nil) {
        self.host = host
        self.path = path
        self.body = body
    }
}
