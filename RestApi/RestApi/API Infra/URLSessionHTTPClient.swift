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
    
    private struct URLSessionTaskWrapper<Seccuss: Sendable, Failure: Error>: HTTPClientTask {
        
        let wrapped: Task<Seccuss, Failure>
        
        func cancel() {
            wrapped.cancel()
        }
        
        func result() async throws -> HTTPClient.Result {
            guard let value = try await wrapped.value as? HTTPClient.Result else {
                throw UnexpectedValuesRepresentation()
            }
            return value
        }
    }
    
    public func makeRequest(from url: URLRequest) async throws -> HTTPClientTask {
        let fetchTask = Task { () -> HTTPClient.Result in
            let (data, response) = try await session.data(for: url)
            
            guard !Task.isCancelled else {
                throw URLError(.cancelled)
            }
            
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                throw UnexpectedValuesRepresentation()
            }
            
            return (data, httpUrlResponse)
        }
        
        return URLSessionTaskWrapper(wrapped: fetchTask)
    }
}
