//
//  OpenAIEndToEndTests.swift
//  OpenAIEndToEndTests
//
//  Created by Salvatore Milazzo on 14/07/23.
//

import XCTest
import LLMFeature
import RestApi

final class OpenAIEndToEndTests: XCTestCase {

    func testExample() async throws {
        
        do {
            let startMessage = LLMMessage(role: "user", content: "Ciao piacere di conoscerti.")
            let firstResponse = try await makeSUT().sendMessage(object: startMessage)
            
            print("ARRIVATO 111")
            
            let newMessage = LLMMessage(role: "user", content: "Sto provando le tue api")
            let secondResponse = try await makeSUT().sendMessage(object: newMessage)
            
            print("ARRIVATO 222")
            
            let newMessage1 = LLMMessage(role: "user", content: "incredibile")
            let thirdResponse = try await makeSUT().sendMessage(object: newMessage1)
            
            print("ARRIVATO 333")
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
