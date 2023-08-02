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
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        
        let wrapped: Task<HTTPClient.Result, Error>
        
        func cancel() {
            wrapped.cancel()
        }
        
        func result() async throws -> HTTPClient.Result {
            return try await wrapped.value
        }
    }
    
    public func makeTaskRequest(from url: URLRequest) async throws -> HTTPClientTask {
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
        
        return URLSessionTaskWrapper(wrapped: fetchTask)
    }
}
