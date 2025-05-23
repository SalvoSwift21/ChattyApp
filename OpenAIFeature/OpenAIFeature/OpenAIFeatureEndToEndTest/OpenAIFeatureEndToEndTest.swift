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
    
    func test_endToEndTestServerGETStreamChatCompletions_notNilResponse() async throws {
        do {
            
            guard let chatStream = try await getStreamChatCompletionsResult() else {
                XCTFail("Expected successful chat completions result, chatStream not work instead")
                return
            }
            
            for try await status in chatStream {
                switch status {
                case .stream(let data):
                    // Gestisci il dato di chat in streaming.
                    print("Dato di chat in streaming: \(data)")
                    XCTAssertNotEqual(data, nil)
                case .finished(let message):
                    // Gestisci il messaggio di completamento.
                    print("Messaggio di completamento: \(message)")
                    XCTAssertNotEqual(message, nil)
                case .error(let error):
                    XCTFail("Expected successful chat completions result, got \(error) instead")
                }
            }
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
    
    private func makeOpenAIHTTPClient(file: StaticString = #filePath, line: UInt = #line) -> OpenAIApiClient {
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let config = LLMConfiguration(API_KEY: OpenAiConfiguration.API_KEY, USER_ID: "testUserFirst")
        
        let sut = OpenAIApiClient(httpClient: client, configuration: config)
        return sut
    }
    
    private func getChatCompletionsResult(file: StaticString = #filePath, line: UInt = #line) async throws -> LLMMessage? {
        let client = makeOpenAIHTTPClient()
        let exp = XCTestExpectation(description: "Wait for load completion")

        let testMessage = LLMMessage(role: "user", content: "Ciao piacere di conoscerti.")
        let requesBody = LLMRequestBody(model: "gpt-3.5-turbo", messages: [testMessage])
        let result = try await client.chatCompletetions(for: requesBody)
        exp.fulfill()
        await fulfillment(of: [exp])
        return result?.genericObject
    }
    
    private func getStreamChatCompletionsResult(file: StaticString = #filePath, line: UInt = #line) async throws -> AsyncThrowingStream<OpenAIApiClient.Status, Error>? {
        let client = makeOpenAIHTTPClient()
        let exp = XCTestExpectation(description: "Wait for load completion")

        let testMessage = LLMMessage(role: "user", content: "Ciao piacere di conoscerti. Spiegami in breve cos'è un linguaggio di programmazione")
        let requesBody = LLMRequestBody(model: "gpt-3.5-turbo", messages: [testMessage], stream: true)
        let result = try await client.chatCompletetionsStream(for: requesBody)
        exp.fulfill()
        await fulfillment(of: [exp])
        return result
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
