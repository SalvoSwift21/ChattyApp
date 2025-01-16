//
//  GoogleAIFeatureTests.swift
//  GoogleAIFeatureTests
//
//  Created by Salvatore Milazzo on 17/10/23.
//


import XCTest
import LLMFeature
import GoogleAIFeature
import GoogleGenerativeAI
import RestApi

class GoogleAIMapperMapperTests: XCTestCase {
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() throws {
        
        let fakeJSONData = """
        {
            "candidates": [],
            "age": 30
        }
        """.data(using: .utf8) ?? Data()
        
        let fakeResponse = try makeGenerateTextResponse(fromJSONData: fakeJSONData)
        XCTAssertThrowsError(
            try GoogleAIMapper.map(fakeResponse) as GoogleAILLMClient.LLMClientResult
        )
    }

    
    func test_map_deliversErrorOn200HTTPResponseWithEmptyJSONCandidatesList() throws {
        let responseEmptyListJSON = try makeGenerateTextResponse(fromJSONData: makeCandidatesJSON([]))
        
        XCTAssertThrowsError(
            try GoogleAIMapper.map(responseEmptyListJSON) as GoogleAILLMClient.LLMClientResult
        )
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONCandidates() throws {
        let item1 = try makeTextCompletion(output: "Test mess 1")
        let item2 = try makeTextCompletion(output: "Test mess 2")
        
        let jsonData = makeCandidatesJSON([item1.json, item2.json])
        let response = try makeGenerateTextResponse(fromJSONData: jsonData)
        
        let result = try GoogleAIMapper.map(response) as GoogleAILLMClient.LLMClientResult
        
        XCTAssertEqual(result?.content, item1.model.parts.first?.text)
    }
    
    // MARK: - Helpers
    
    private func makeGenerateTextResponse(message: LLMMessage) throws -> GenerateContentResponse {
        let modelContent = ModelContent(parts: message.content)
        let candides = CandidateResponse(content: modelContent, safetyRatings: [], finishReason: nil, citationMetadata: nil)
        let item = GenerateContentResponse(candidates: [candides], promptFeedback: nil)
        return item
    }
    
    private func makeGenerateTextResponse(fromJSONData data: Data) throws -> GenerateContentResponse {
        let item = try JSONDecoder().decode(GenerateContentResponse.self, from: data)
        return item
    }
    
    private func makeTextCompletion(output: String) throws -> (model: ModelContent, json: [String: Any]) {
        let item = ModelContent(parts: output)
        let json: [String : Any] = ["content": try item.asDictionary().compactMapValues { $0 }, "safetyRatings": []]
        return (item, json)
    }
    
    func makeCandidatesJSON(_ candidates: [[String: Any]]) -> Data {
        let json: [String : Any] = ["candidates": candidates]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
