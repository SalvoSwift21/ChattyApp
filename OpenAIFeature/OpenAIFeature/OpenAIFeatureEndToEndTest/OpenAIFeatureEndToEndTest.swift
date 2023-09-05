//
//  OpenAIFeatureEndToEndTEst.swift
//  OpenAIFeatureEndToEndTEst
//
//  Created by Salvatore Milazzo on 05/09/23.
//

import XCTest
import LLMFeature
import OpenAIFeature
import RestApi

final class OpenAIEndToEndTests: XCTestCase {
    
    func test_endToEndTestServerGETChatCompletions_notNilResponse() async throws {
        do {
            let responseMessage = try await getChatCompletionsResult()
            XCTAssertNotEqual(responseMessage, nil)
        } catch {
            XCTFail("Expected successful chat completions result, got \(error) instead")
        }
    }
    
    func test_endToEndTestServerGETModels_notNilResponse() async throws {
        do {
            let response = try await getModelsResult()
            XCTAssertNotEqual(response?.count, 0)
        } catch {
            XCTFail("Expected successful models result, got \(error) instead")
        }
    }
    
    // MARK: - Helpers
    
    private func makeOpenAIHTTPClient(file: StaticString = #filePath, line: UInt = #line) -> OpenAIHTTPClient {
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let config = LLMConfiguration(API_KEY: OpenAiConfiguration.TEST_API_KEY, USER_ID: "testUserFirst")
        
        let sut = OpenAIHTTPClient(httpClient: client, configuration: config)
        return sut
    }
    
    private func getChatCompletionsResult(file: StaticString = #filePath, line: UInt = #line) async throws -> LLMMessage? {
        let client = makeOpenAIHTTPClient()
        let exp = XCTestExpectation(description: "Wait for load completion")

        let testMessage = LLMMessage(role: "user", content: "Ciao piacere di conoscerti.")
        let result = try await client.chatCompletetions(for: [testMessage])
        exp.fulfill()
        await fulfillment(of: [exp])
        return result?.genericObject
    }
    
    private func getModelsResult(file: StaticString = #filePath, line: UInt = #line) async throws -> [OpenAIModel]? {
        let client = makeOpenAIHTTPClient()
        let exp = XCTestExpectation(description: "Wait for load completion")

        let result = try await client.getAIModels()
        exp.fulfill()
        await fulfillment(of: [exp])
        return result
    }
}
