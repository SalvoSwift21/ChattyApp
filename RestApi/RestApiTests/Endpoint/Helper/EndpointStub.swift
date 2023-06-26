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
    
    var host: String {
        "any-url.com"
    }
    
    var path: String {
        "/v1/try"
    }
    
    var method: RestApi.RequestMethod {
        .GET
    }
    
    var query: [String : String]? {
        ["limit": "10"]
    }
    
    var header: [String : String]? {
        ["Auth": "Test token"]
    }
    
    var body: [String : Any]? {
        ["body": ["test1, test2"]]
    }
}
