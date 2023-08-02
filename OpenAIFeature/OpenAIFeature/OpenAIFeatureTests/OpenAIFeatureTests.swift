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

    
    
    func testExample() async throws {
        let sut = makeSUT()
        do {
            let startMessage = LLMMessage(role: "user", content: "Ciao piacere di conoscerti.")
            let firstResponse = try await sut.sendMessage(object: startMessage)
            
            print("ARRIVATO 111")
            
        } catch {
            print("error \(error.localizedDescription)")
        }
        
    }

    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> OpenAILLMClient {
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let config = LLMConfiguration(API_KEY: OpenAiConfiguration.TEST_API_KEY, USER_ID: "testUserFirst")
        let sut = OpenAILLMClient(httpClient: client, configuration: config)
        return sut
    }

}
