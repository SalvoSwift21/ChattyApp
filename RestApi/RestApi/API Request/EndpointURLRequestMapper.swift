//
//  EndpointURLRequestMapper.swift
//  RestApi
//
//  Created by Salvatore Milazzo on 23/06/23.
//

import Foundation

public final class EndpointURLRequestMapper {
    
    public enum Error: Swift.Error {
        case invalidEndpoint
        case invalidBody
    }
    
    public static func map(from endpoint: Endpoint) throws -> URLRequest {
        var request: URLRequest
        
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.host
        components.path = endpoint.path
        components.queryItems = endpoint.query?.map({ URLQueryItem(name: $0.key, value: $0.value )}).compactMap { $0 }
        
        guard let url = components.url else {
            throw Error.invalidEndpoint
        }
        
        request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            do {
                request.httpBody = try mapBody(body)
            } catch {
                debugPrint("Body malformatter with error: \(error)")
                throw Error.invalidBody
            }
        }
        
        return request
    }
    
    private static func mapBody(_ body: [String: Any]) throws -> Data? {
        try JSONSerialization.data(withJSONObject: body, options: [])
    }
}
