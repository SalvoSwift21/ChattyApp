//
//  GoogleAIFeatureEndToEndTest.swift
//  GoogleAIFeatureEndToEndTest
//
//  Created by Salvatore Milazzo on 17/10/23.
//

import XCTest
import LLMFeature
import GoogleAIFeature
import GoogleGenerativeAI
import RestApi

final class GoogleAIFeatureEndToEndTest: XCTestCase {
    
    func test_endToEndTestServerGETTextSummarise_notNilResponse() async throws {
        do {
            let responseMessage = try await getSummariseText()
            debugPrint(responseMessage?.content ?? "No response")
            XCTAssertNotEqual(responseMessage, nil)
        } catch {
            XCTFail("Expected successful chat completions result, got \(error) instead")
        }
    }
    
    // MARK: - Helpers
    
    private func makeOpenAIHTTPClient(file: StaticString = #filePath, line: UInt = #line) -> GoogleAILLMClient {
        let gl = GenerativeLanguage(apiKey: GoogleAIConfigurations.TEST_API_KEY)
        let sut = GoogleAILLMClient(generativeLanguageClient: gl)
        return sut
    }

    private func getSummariseText(file: StaticString = #filePath, line: UInt = #line) async throws -> LLMMessage? {
        let client = makeOpenAIHTTPClient()
        let exp = XCTestExpectation(description: "Wait for load completion")
        let prompt = "Summarise the following text: https://it.wikipedia.org/wiki/Seconda_guerra_mondiale"
        let llmMessage = LLMMessage(role: "user", content: prompt)
        let result = try await client.sendMessage(object: llmMessage)
        exp.fulfill()
        await fulfillment(of: [exp])
        return result
    }
}

