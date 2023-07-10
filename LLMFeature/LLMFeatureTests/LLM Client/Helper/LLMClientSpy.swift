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

    private var sendMessageTask: Task<String, Error>?
    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    
    private enum Error: Swift.Error {
        case invalidBody
    }
    
    func sendMessage(text: String) async throws -> String {
        receivedMessages.append(.sendMessage)
        let userText = "user + \(text)"
        //self.sendMessageTask = Task {
        //    throw Error.invalidBody
        //    return "assistance + \(text)"
        //}
        return try await self.sendMessageTask?.value ?? ""
    }
    
    private func completeSendMessage(with error: Error) {
        
    }
    
    func completeInsertionSuccessfully() {
        insertionResult = .success(())
    }
    
    func saveInHistory(userText: String, responseText: String) async throws {
        
    }
    
    func deleteFromHistory() {
        
    }
}
