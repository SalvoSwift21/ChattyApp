//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

func anyHost() -> String {
    return "any-host.com"
}

func anyWrongHost() -> String {
    return "test!!??5632gft\\\\"
}

func anyWrongBody() -> [String: Any] {
    return ["age": [30: 20]]
}

func anyNSError() -> NSError {
	return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
	return URL(string: "http://any-url.com")!
}

func anyURLRequest() -> URLRequest {
    return URLRequest(url: anyURL())
}

func anyData() -> Data {
	return Data("any data".utf8)
}

func makeDataFromItemsJSON(_ items: [String: Any]) -> Data {
	let json = items
	return try! JSONSerialization.data(withJSONObject: json)
}

extension HTTPURLResponse {
	convenience init(statusCode: Int) {
		self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
	}
}
