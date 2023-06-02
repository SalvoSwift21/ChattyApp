//
// Copyright © Essential Developer. All rights reserved.
//

import XCTest
import RestApi
import Combine

class URLSessionHTTPClientTests: XCTestCase {
	
    private var cancellables: Set<AnyCancellable> = []

	override func tearDown() {
		super.tearDown()
		
		URLProtocolStub.removeStub()
        self.cancellables.removeAll()
	}
	
    func test_getFromURL_performsGETRequestWithURL() async {
        let urlRequest = anyURLRequest()
		let exp = expectation(description: "Wait for request")
		
		URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, urlRequest.url)
			XCTAssertEqual(request.httpMethod, "GET")
			exp.fulfill()
		}
		
        await makeSUT()
            .makeRequest(from: urlRequest)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1.0)
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
        
        await makeSUT()
            .makeRequest(from: urlRequest)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1.0)
    }
	
    func test_cancelGetFromURLTask_cancelsURLRequest() async {
		let exp = expectation(description: "Wait for request")
		URLProtocolStub.observeRequests { _ in exp.fulfill() }
		
        let receivedError = await resultErrorFor(taskHandler: { anyCancellaber in
            anyCancellaber.cancel()
        }) as NSError?
		wait(for: [exp], timeout: 1.0)
		
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
		let result = await resultFor(values, file: file, line: line)
		
		switch result {
		case let .success(values):
			return values
		default:
			XCTFail("Expected success, got \(result) instead", file: file, line: line)
			return nil
		}
	}
	
    private func resultErrorFor(_ values: (data: Data?, response: URLResponse?, error: Error?)? = nil, taskHandler: (AnyCancellable) -> Void = { _ in }, file: StaticString = #filePath, line: UInt = #line) async -> Error? {
        let result = await resultFor(values, taskHandler: taskHandler, file: file, line: line)
		
		switch result {
		case let .failure(error):
			return error
		default:
			XCTFail("Expected failure, got \(result) instead", file: file, line: line)
			return nil
		}
	}
    
    private func resultFor(_ values: (data: Data?, response: URLResponse?, error: Error?)?, taskHandler: (AnyCancellable) -> Void = { _ in }, file: StaticString = #filePath, line: UInt = #line) async -> HTTPClient.Result {
        
        values.map { URLProtocolStub.stub(data: $0, response: $1, error: $2) }
        
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")
        
        var receivedResult: HTTPClient.Result!
        
        let request = await sut.makeRequest(from: anyURLRequest())
            .handleEvents(receiveCancel: {
                print("API request was cancelled")
                receivedResult = .failure(URLError(.cancelled))
                exp.fulfill()
            })
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    receivedResult = .failure(error)
                }
                exp.fulfill()
            }, receiveValue: { value in
                receivedResult = .success(value)
            })
        taskHandler(request)
        request.store(in: &cancellables)
        wait(for: [exp], timeout: 1.0)
        return receivedResult
    }
	
	private func anyHTTPURLResponse() -> HTTPURLResponse {
		return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
	}
	
	private func nonHTTPURLResponse() -> URLResponse {
		return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
	}
	
}
