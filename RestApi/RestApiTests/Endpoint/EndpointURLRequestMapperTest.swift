//
//  EndpointTests.swift
//  RestApiTests
//
//  Created by Salvatore Milazzo on 26/06/23.
//

import XCTest
import RestApi

class EndpointURLRequestMapperTest: XCTestCase {
    
    func test_map_noThrowsErrorURLRequestFromEndpoint() throws {
        let stubEndpoint = EndpointStub(host: anyHost())
        
        XCTAssertNoThrow(
            try EndpointURLRequestMapper.map(from: stubEndpoint)
        )
    }
    
    func test_map_throwsErrorOnInvalidEndpoint() throws {
        let endpoint = EndpointStub(host: anyHost(), path: "v1 test")
        
        XCTAssertThrowsError(try EndpointURLRequestMapper.map(from: endpoint)) { error in
            XCTAssert(error as? EndpointURLRequestMapper.Error == EndpointURLRequestMapper.Error.invalidEndpoint)
        }
    }
    
    func test_map_throwsErrorOnMalformatterBody() throws {
        let endpoint = EndpointStub(host: anyHost(), body: anyWrongBody())
        
        XCTAssertThrowsError(try EndpointURLRequestMapper.map(from: endpoint)) { error in
            XCTAssert(error as? EndpointURLRequestMapper.Error == EndpointURLRequestMapper.Error.invalidBody)
        }
    }
    
    func test_map_URLRequestFromEndpoint() {
        let body: [String: Any] = ["some": "data"]
        let stubEndpoint = EndpointStub(host: anyHost(), body: body)
        
        do {
            let received = try EndpointURLRequestMapper.map(from: stubEndpoint)
            //TEST URL
            XCTAssertEqual(received.url?.scheme, stubEndpoint.scheme.rawValue, "scheme")
            XCTAssertEqual(received.url?.host, stubEndpoint.host, "host")
            XCTAssertEqual(received.url?.path, stubEndpoint.path, "path")
            let query = stubEndpoint.query?.first?.value ?? ""
            XCTAssertEqual(received.url?.query?.contains(query), true, "limit query param")
            //TEST REQUEST
            XCTAssertEqual(received.allHTTPHeaderFields, stubEndpoint.header, "check token")
            XCTAssertEqual(received.httpMethod, stubEndpoint.method.rawValue)
            XCTAssertEqual(received.httpBody, makeDataFromItemsJSON(body))
        } catch {
            XCTFail("Expect no error in generate URLRequest, error \(error.localizedDescription)")
        }
    }
    
}
