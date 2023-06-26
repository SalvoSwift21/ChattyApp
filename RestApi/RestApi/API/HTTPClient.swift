//
//  Copyright © Essential Developer. All rights reserved.
//

import Foundation
import Combine

public protocol HTTPClientTask {
	func cancel()
    
    @discardableResult
    func result() async throws -> HTTPClient.Result
}

public protocol HTTPClient {
	//typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    typealias Result = (Data, HTTPURLResponse)
    typealias Publisher = AnyPublisher<(Data, HTTPURLResponse), Error>
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    @discardableResult
    func makeTaskRequest(from url: URLRequest) async throws -> HTTPClientTask
}
