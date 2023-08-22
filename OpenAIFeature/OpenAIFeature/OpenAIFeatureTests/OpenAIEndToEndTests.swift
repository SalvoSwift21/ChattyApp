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

final class OpenAIEndToEndTests: XCTestCase {

    
    
    func test_endToEndTestServerGETChatCompletions_notNilResponse() async throws {
        do {
            let responseMessage = try await getChatCompletionsResult()
            XCTAssertNotEqual(responseMessage, nil)
        } catch {
            XCTFail("Expected successful chat completions result, got \(error) instead")
        }
    }

    
    // MARK: - Helpers
    
    private func makeOpenAIClient(file: StaticString = #filePath, line: UInt = #line) -> OpenAILLMClient {
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let config = LLMConfiguration(API_KEY: OpenAiConfiguration.TEST_API_KEY, USER_ID: "testUserFirst")
        let sut = OpenAILLMClient(httpClient: client, configuration: config)
        return sut
    }
    
    private func getChatCompletionsResult(file: StaticString = #filePath, line: UInt = #line) async throws -> LLMMessage? {
        let client = makeOpenAIClient()
        let exp = XCTestExpectation(description: "Wait for load completion")

        let testMessage = LLMMessage(role: "user", content: "Ciao piacere di conoscerti.")
        let result = try await client.sendMessage(object: testMessage)
        exp.fulfill()
        await fulfillment(of: [exp])
        return result
    }
    
    private func fixedResponse() -> String {
        "Ciao, piacere di conoscerti anche a te! Come posso aiutarti oggi?"
    }
}
