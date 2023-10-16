//
//  StreamHTTPClientResult.swift
//  RestApi
//
//  Created by Salvatore Milazzo on 20/09/23.
//

import Foundation

public struct StreamHTTPClientTask: HTTPClientTask {
    
    let wrapped: Task<HTTPClient.StreamResult, Error>
    
    public func cancel() {
        wrapped.cancel()
    }
    
    @discardableResult
    public func result() async throws -> HTTPClient.StreamResult {
        return try await wrapped.value
    }
}
