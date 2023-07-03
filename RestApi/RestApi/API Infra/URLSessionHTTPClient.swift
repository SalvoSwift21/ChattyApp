//
//  Copyright © Essential Developer. All rights reserved.
//

import Foundation
import Combine

public final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
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
            
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                throw UnexpectedValuesRepresentation()
            }
            
            return (data, httpUrlResponse)
        }
        
        return URLSessionTaskWrapper(wrapped: fetchTask)
    }
}
