//
//  LLMOpenAi.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import Foundation
import LLMFeature


class LLMClientSpy: LLMClient {
    
    typealias LLMClientResult = String
    
    enum ReceivedMessage: Equatable {
        case sendMessage
        case insert([String])
        case deleteFromHistory
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()

    private var deletionResult: Result<Void, Error>?
    private var sendMessageResult: Result<Void, Error>?
    
    enum Error: Swift.Error {
        case invalidResult
    }
    
    public func sendMessage(text: String) async throws -> String {
        let userText = "user + \(text)"
        let task = Task { () -> LLMClientResult in
            guard let result = sendMessageResult else { throw Error.invalidResult }
            switch result {
            case .success(_):
                receivedMessages.append(.sendMessage)
                return "assistance + \(text)"
            case .failure(let failure):
                throw failure
            }
        }
        return try await task.value
    }
    
    func completeSendMessage(with error: Error) {
        sendMessageResult = .failure(error)
    }
    
    func completeSendMessageSuccessfully() {
        sendMessageResult = .success(())
    }
    
    func saveInHistory(userText: String, responseText: String) async throws {
        
    }
    
    func deleteFromHistory() {
        
    }
}
