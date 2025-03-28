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
    
    //MARK: Send message
    
    func test_send_requestSendMessagge() async {
        let sut = makeSUT()
                
        let _ = try? await sut.sendMessage(object: "test user")
        
        XCTAssertEqual(sut.receivedMessages, [.sendMessage])
    }
    
    func test_send_succeedsOnSuccessfulSendMessage() async {
        let sut = makeSUT()
        
        sut.completeSendMessageSuccessfully()
        
        do {
            let _ = try await sut.sendMessage(object: "test")
            debugPrint("Success")
        } catch {
            XCTFail("Expect success, got error: \(error.localizedDescription)")
        }
    }
    
    func test_send_failsOnSendMessageError() async {
        let sut = makeSUT()
        
        sut.completeSendMessage(with: LLMClientSpy.SendError.failed)
        
        do {
            let _ = try await sut.sendMessage(object: "test")
            XCTFail("Expect Error, got success")
        } catch {
            XCTAssert(error as? LLMClientSpy.SendError == LLMClientSpy.SendError.failed)
        }
    }
    
    //MARK: Save history
    
    func test_saveHistory_requestsSave() async {
        let sut = makeSUT()
        let userText = "user text"
        let responseText = "response text"
        
        try? await sut.saveInHistory(newObject: userText)
        try? await sut.saveInHistory(newObject: responseText)

        XCTAssertEqual(sut.receivedMessages, [.insert([userText]), .insert([responseText])])
    }
    
    func test_saveHistory_failsOnInsertionError() async {
        let sut = makeSUT()
        let userText = "user text"
        let responseText = "response text"
        
        sut.completeSaveInHistory(with: LLMClientSpy.SaveHistoryError.failed)
        
        do {
            try await sut.saveInHistory(newObject: userText)
            try await sut.saveInHistory(newObject: responseText)
            XCTFail("Expect Error, got success")
        } catch {
            XCTAssert(error as? LLMClientSpy.SaveHistoryError == LLMClientSpy.SaveHistoryError.failed)
        }
        
    }
    
    func test_saveHistory_succeedsOnSuccessfulInsertion() async {
        let sut = makeSUT()
        let userText = "user text"
        let responseText = "response text"
        
        sut.completeSaveInHistorySuccessfully()
        
        do {
            try await sut.saveInHistory(newObject: userText)
            try await sut.saveInHistory(newObject: responseText)
            debugPrint("Success")
        } catch {
            XCTFail("Expect success, got error: \(error.localizedDescription)")
        }
    }
    
    //MARK: Delete history
    
    func test_deleteHistory_requestsDeleteHistory() async {
        let sut = makeSUT()
                
        let _ = try? await sut.deleteFromHistory()
        
        XCTAssertEqual(sut.receivedMessages, [.deleteFromHistory])
    }
    
    func test_deleteHistory_succeedsOnSuccessfulDelete() async {
        let sut = makeSUT()
        
        sut.completeDeletionSuccessfully()
        
        do {
            try await sut.deleteFromHistory()
            debugPrint("Success")
        } catch {
            XCTFail("Expect success, got error: \(error.localizedDescription)")
        }
    }
    
    func test_deleteHistory_failsOnDeleteError() async {
        let sut = makeSUT()
        
        sut.completeDeletion(with: LLMClientSpy.DeleteHistoryError.failed)
        
        do {
            let _ = try await sut.deleteFromHistory()
            XCTFail("Expect Error, got success")
        } catch {
            XCTAssert(error as? LLMClientSpy.DeleteHistoryError == LLMClientSpy.DeleteHistoryError.failed)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> LLMClientSpy {
        let sut = LLMClientSpy()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
