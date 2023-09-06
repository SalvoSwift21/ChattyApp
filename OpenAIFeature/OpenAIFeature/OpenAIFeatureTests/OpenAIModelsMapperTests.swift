//
//  test.swift
//  OpenAIFeatureTests
//
//  Created by Salvatore Milazzo on 06/09/23.
//

import XCTest
import LLMFeature
import OpenAIFeature
import RestApi

class OpenAIModelsMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeModelsJSON([])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try OpenAIModelsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try OpenAIModelsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONChoicesList() throws {
        let emptyListJSON = makeModelsJSON([])
        
        let result = try OpenAIModelsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result.count, 0)
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONChoices() throws {
        let item1 = try makeModel(modelId: "gpt_3")
        
        let item2 = try makeModel(modelId: "gpt_4")
        
        let json = makeModelsJSON([item1.json, item2.json])
        
        let result = try OpenAIModelsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    // MARK: - Helpers
    
    private func makeModel(modelId: String) throws -> (model: OpenAIModel, json: [String: Any]) {
        let item = OpenAIModel(id: modelId, owned_by: "test_open_ai")
        let json = try item.asDictionary().compactMapValues { $0 }
        return (item, json)
    }
}
