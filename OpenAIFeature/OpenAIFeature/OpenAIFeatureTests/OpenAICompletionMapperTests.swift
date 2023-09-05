//
//  OpenAIFeatureTests.swift
//  OpenAIFeatureTests
//
//  Created by Salvatore Milazzo on 02/08/23.
//

import XCTest
import LLMFeature
import OpenAIFeature
import RestApi

class OpenAICompletionMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try OpenAICompletionMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try OpenAICompletionMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONChoicesList() throws {
        let emptyListJSON = makeItemsJSON([])
        
        let result = try OpenAICompletionMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result.genericObject, nil)
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONChoices() throws {
        let item1 = try makeChoice(finishReason: "Test 1", message: LLMMessage(role: "user", content: "test user"))
        
        let item2 = try makeChoice(message: LLMMessage(role: "boot", content: "test boot"))
        
        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try OpenAICompletionMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result.genericObject, item1.model.message)
    }
    
    // MARK: - Helpers
    
    private func makeChoice(finishReason: String? = nil, message: LLMMessage) throws -> (model: Choice, json: [String: Any]) {
        let item = Choice(finish_reason: finishReason, message: message)
        let json = try item.asDictionary().compactMapValues { $0 }
        return (item, json)
    }
}
