//
//  Copyright © Essential Developer. All rights reserved.
//

import os
import Foundation
import Combine

public final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    private lazy var logger = Logger(subsystem: "com.ariel.one.RestAPI", category: "httpclient")
    
    public init(session: URLSession) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private struct URLSessionTaskWrapper<T>: HTTPClientTask {
        
        typealias T = T
        
        let wrapped: Task<T, Error>
        
        func cancel() {
            wrapped.cancel()
        }
        
        func result() async throws -> (T) {
            return try await wrapped.value
        }
    }
    
    public func makeTaskRequest(from url: URLRequest) async throws -> any HTTPClientTask {
        let fetchTask = Task { () -> HTTPClient.Result in
            let (data, response) = try await session.data(for: url)
            
            //Debug request
            logger.debug("\(url)")
        
            if let JSONString = String(data: url.httpBody ?? Data(), encoding: String.Encoding.utf8) {
                logger.debug("Body: \(JSONString)")
            }

            
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                logger.fault("Response is not a HTTPURLResponse")
                throw UnexpectedValuesRepresentation()
            }
            
           
            if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                logger.debug("\(JSONString)")
            }
            
            return (data, httpUrlResponse)
        }
        
        return URLSessionTaskWrapper<HTTPClient.Result>(wrapped: fetchTask)
    }
    
    
    public func makeStreamTaskRequest(from url: URLRequest) async throws -> any HTTPClientTask {
        let fetchTask = Task { () -> HTTPClient.StreamResult in
            let (stream, response) = try await session.bytes(for: url)
            
            //Debug request
            logger.debug("\(url)")
        
            if let JSONString = String(data: url.httpBody ?? Data(), encoding: String.Encoding.utf8) {
                logger.debug("Body: \(JSONString)")
            }

            
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                logger.fault("Response is not a HTTPURLResponse")
                throw UnexpectedValuesRepresentation()
            }
            
            return (stream, httpUrlResponse)
        }
        
        return URLSessionTaskWrapper<HTTPClient.StreamResult>(wrapped: fetchTask)
    }
}
