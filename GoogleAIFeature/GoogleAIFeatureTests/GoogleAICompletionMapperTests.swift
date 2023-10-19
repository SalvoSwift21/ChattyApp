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
            "name": "John Doe",
            "age": 30
        }
        """.data(using: .utf8) ?? Data()
        
        let fakeResponse = try makeGenerateTextResponse(fromJSONData: fakeJSONData)
        XCTAssertThrowsError(
            try GoogleAIMapper.map(fakeResponse)
        )
    }

    
    func test_map_deliversErrorOn200HTTPResponseWithEmptyJSONCandidatesList() throws {
        let responseEmptyListJSON = try makeGenerateTextResponse(fromJSONData: makeCandidatesJSON([]))
        
        XCTAssertThrowsError(
            try GoogleAIMapper.map(responseEmptyListJSON)
        )
    }
    
    func test_map_deliversErrorOn200HTTPResponseWithWrgonJSONFirstTextCompletion() throws {
        
        let item1 = try makeTextCompletion(output: nil)
        
        let jsonData = makeCandidatesJSON([item1.json])
        let response = try makeGenerateTextResponse(fromJSONData: jsonData)
        
        XCTAssertThrowsError(
            try GoogleAIMapper.map(response)
        )
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONCandidates() throws {
        let item1 = try makeTextCompletion(output: "Test mess 1")
        let item2 = try makeTextCompletion(output: "Test mess 2")
        
        let jsonData = makeCandidatesJSON([item1.json, item2.json])
        let response = try makeGenerateTextResponse(fromJSONData: jsonData)
        
        let result = try GoogleAIMapper.map(response)
        
        XCTAssertEqual(result?.content, item1.model.output)
    }
    
    // MARK: - Helpers
    
    private func makeGenerateTextResponse(message: LLMMessage) throws -> GenerateTextResponse {
        let candides = TextCompletion(output: message.content)
        let item = GenerateTextResponse(candidates: [candides])
        return item
    }
    
    private func makeGenerateTextResponse(fromJSONData data: Data) throws -> GenerateTextResponse {
        
        let item = try JSONDecoder().decode(GenerateTextResponse.self, from: data)
        return item
    }
    
    private func makeTextCompletion(output: String?) throws -> (model: TextCompletion, json: [String: Any]) {
        let item = TextCompletion(output: output)
        let json = try item.asDictionary().compactMapValues { $0 }
        return (item, json)
    }
    
    func makeCandidatesJSON(_ candidates: [[String: Any]]) -> Data {
        let json: [String : Any] = ["candidates": candidates]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}

