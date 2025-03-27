//
//  HTTPRequest.swift
//  RestApi
//
//  Created by Salvatore Milazzo on 23/06/23.
//

import Foundation

public protocol Endpoint {
    var scheme: Schema { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var query: [String: String]? { get }
    var header: [String: String]? { get }
    var body: [String: Any]? { get }
}


public enum Schema: String {
    case HTTP = "http"
    case HTTPS = "https"
}

public enum RequestMethod: String {
    case GET, PUT, DELETE, POST
}
