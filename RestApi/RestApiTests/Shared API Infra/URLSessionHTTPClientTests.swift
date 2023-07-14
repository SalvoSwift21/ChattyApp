//
// Copyright © Essential Developer. All rights reserved.
//

import XCTest
import RestApi
import Combine

class URLSessionHTTPClientTests: XCTestCase {
	
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
    }

	override func tearDown() {
		super.tearDown()
		URLProtocolStub.removeStub()
	}
	
    func test_getFromURL_performsGETRequestWithURL() async {
        let urlRequest = anyURLRequest()
		let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, urlRequest.url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        do {
            try await makeSUT().makeTaskRequest(from: urlRequest).result()
        } catch {
            print("Error in getFromUrl: \(error.localizedDescription) expect success")
        }
        
        await fulfillment(of: [exp], timeout: 1.0)
	}
    
    func test_postToURL_performsPOSTRequestWithURL() async {
        var urlRequest = anyURLRequest()
        urlRequest.httpMethod = "POST"
        let exp = expectation(description: "Wait for request")
    
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, urlRequest.url)
            XCTAssertEqual(request.httpMethod, "POST")
            exp.fulfill()
        }
    
        do {
            try await makeSUT().makeTaskRequest(from: urlRequest).result()
        } catch {
            print("Error in postToURL: \(error.localizedDescription) expect success")
        }
    
        await fulfillment(of: [exp], timeout: 1.0)
    }
	
    func test_cancelGetFromURLTask_cancelsURLRequest() async {
		let exp = expectation(description: "Wait for request")
		URLProtocolStub.observeRequests { _ in
            exp.fulfill()
        }
	
        let receivedError = await resultErrorFor(taskHandler: {
            $0.cancel()
        }) as NSError?
        await fulfillment(of: [exp], timeout: 1.0)
	
		XCTAssertEqual(receivedError?.code, URLError.cancelled.rawValue)
	}
	
	func test_getFromURL_failsOnRequestError() async {
		let requestError = anyNSError()
	
		let receivedError = await resultErrorFor((data: nil, response: nil, error: requestError))
	
		XCTAssertNotNil(receivedError)
	}
    
    
	func test_getFromURL_failsOnAllInvalidRepresentationCases() async {
        let results = await [resultErrorFor((data: nil, response: nil, error: nil)),
                             resultErrorFor((data: nil, response: nonHTTPURLResponse(), error: nil)),
                             resultErrorFor((data: anyData(), response: nil, error: nil)),
                             resultErrorFor((data: anyData(), response: nil, error: anyNSError())),
                             resultErrorFor((data: nil, response: nonHTTPURLResponse(), error: anyNSError())),
                             resultErrorFor((data: nil, response: anyHTTPURLResponse(), error: anyNSError())),
                             resultErrorFor((data: anyData(), response: nonHTTPURLResponse(), error: anyNSError())),
                             resultErrorFor((data: anyData(), response: anyHTTPURLResponse(), error: anyNSError())),
                             resultErrorFor((data: anyData(), response: nonHTTPURLResponse(), error: nil))]
    
        for result in results {
            XCTAssertNotNil(result)
        }
	}
	
	func test_getFromURL_succeedsOnHTTPURLResponseWithData() async {
		let data = anyData()
		let response = anyHTTPURLResponse()
	
		let receivedValues = await resultValuesFor((data: data, response: response, error: nil))
	
		XCTAssertEqual(receivedValues?.data, data)
		XCTAssertEqual(receivedValues?.response.url, response.url)
		XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
	}
	
	func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() async {
		let response = anyHTTPURLResponse()
	
        let receivedValues = await resultValuesFor((data: nil, response: response, error: nil))
	
		let emptyData = Data()
		XCTAssertEqual(receivedValues?.data, emptyData)
		XCTAssertEqual(receivedValues?.response.url, response.url)
		XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
	}
	
	// MARK: - Helpers
	
	private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
		let configuration = URLSessionConfiguration.ephemeral
		configuration.protocolClasses = [URLProtocolStub.self]
		let session = URLSession(configuration: configuration)
		
		let sut = URLSessionHTTPClient(session: session)
		trackForMemoryLeaks(sut, file: file, line: line)
		return sut
	}
	
	private func resultValuesFor(_ values: (data: Data?, response: URLResponse?, error: Error?), file: StaticString = #filePath, line: UInt = #line) async -> (data: Data, response: HTTPURLResponse)? {
        do {
            let result = try await resultFor(values, file: file, line: line)
            return result
        } catch {
            XCTFail("Expected success, got \(error.localizedDescription) instead", file: file, line: line)
            return nil
        }
	}
	
    private func resultErrorFor(_ values: (data: Data?, response: URLResponse?, error: Error?)? = nil, taskHandler: (HTTPClientTask) -> Void = { _ in }, file: StaticString = #filePath, line: UInt = #line) async -> Error? {
        do {
            let result = try await resultFor(values, taskHandler: taskHandler, file: file, line: line)
            XCTFail("Expected failure, got \(result) instead", file: file, line: line)
            return nil
        } catch {
            return error
        }
	}
    
    private func resultFor(_ values: (data: Data?, response: URLResponse?, error: Error?)?, taskHandler: (HTTPClientTask) -> Void = { _ in }, file: StaticString = #filePath, line: UInt = #line) async throws -> HTTPClient.Result {
        
        values.map { URLProtocolStub.stub(data: $0, response: $1, error: $2) }
        let sut = makeSUT(file: file, line: line)
        
        let clientTask = try await sut.makeTaskRequest(from: anyURLRequest())
        taskHandler(clientTask)
        let response = try await clientTask.result()
        
        return response
    }
	
	private func anyHTTPURLResponse() -> HTTPURLResponse {
		return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
	}
	
	private func nonHTTPURLResponse() -> URLResponse {
		return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
	}
	
}
