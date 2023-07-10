//
//  LLMClientTest.swift
//  LLMFeatureTests
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import XCTest
import LLMFeature

class LLMClientTest: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.receivedMessages, [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> LLMClientSpy {
        let sut = LLMClientSpy()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
}
