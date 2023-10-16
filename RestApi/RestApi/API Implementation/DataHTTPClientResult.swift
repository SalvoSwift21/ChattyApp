//
//  DataHTTPClientResult.swift
//  RestApi
//
//  Created by Salvatore Milazzo on 20/09/23.
//

import Foundation

public struct DataHTTPClientTask: HTTPClientTask {
    
    let wrapped: Task<HTTPClient.Result, Error>
    
    public func cancel() {
        wrapped.cancel()
    }
    
    @discardableResult
    public func result() async throws -> HTTPClient.Result {
        return try await wrapped.value
    }
}
