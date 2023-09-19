//
//  Copyright © Essential Developer. All rights reserved.
//

import Foundation
import Combine

public protocol HTTPClientTask {
    associatedtype T
    
	func cancel()
    
    @discardableResult
    func result() async throws -> (T)
}

public protocol HTTPClient {

    typealias Result = (Data, HTTPURLResponse)
    typealias StreamResult = (URLSession.AsyncBytes, HTTPURLResponse)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    @discardableResult
    func makeTaskRequest(from url: URLRequest) async throws -> any HTTPClientTask
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    @discardableResult
    func makeStreamTaskRequest(from url: URLRequest) async throws -> any HTTPClientTask
}
