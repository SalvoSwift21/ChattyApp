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
    
    func test_send_sendMessageWithSuccess() async {
        let sut = makeSUT()
        
        sut.completeSendMessageSuccessfully()
        
        do {
            let _ = try await sut.sendMessage(text: "test")
            XCTAssertEqual(sut.receivedMessages, [.sendMessage])
        } catch {
            XCTFail("Expect success, got error: \(error.localizedDescription)")
        }
    }
    
    func test_send_sendMessageWithError() async {
        let sut = makeSUT()
        
        sut.completeSendMessage(with: .invalidResult)
        
        do {
            let _ = try await sut.sendMessage(text: "test")
            XCTFail("Expect Error, got success")
        } catch {
            XCTAssert(error as? LLMClientSpy.Error == LLMClientSpy.Error.invalidResult)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> LLMClientSpy {
        let sut = LLMClientSpy()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    //private func expect(_ sut: LLMClientSpy, toCompleteWith expectedResult: Result<Void, Error>, when action: () -> Void, file: StaticString = //#filePath, line: UInt = #line) {
    //    action()
//
    //    let receivedResult = Result { try sut.se }
//
    //    switch (receivedResult, expectedResult) {
    //    case (.success, .success):
    //        break
    //
    //    case (.failure(let receivedError as LocalFeedImageDataLoader.SaveError),
    //          .failure(let expectedError as LocalFeedImageDataLoader.SaveError)):
    //        XCTAssertEqual(receivedError, expectedError, file: file, line: line)
    //
    //    default:
    //        XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
    //    }
    //}
    
}
