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
    
    public enum SendError: Error {
        case failed
    }
    
    public enum SaveHistoryError: Error {
        case failed
    }
    
    public enum DeleteHistoryError: Error {
        case failed
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()

    private var deletionResult: Result<Void, Error>?
    private var sendMessageResult: Result<Void, Error>?
    private var saveInHistoryMessageResult: Result<Void, Error>?

    public func sendMessage(text: String) async throws -> String {
        receivedMessages.append(.sendMessage)
        let task = Task { () -> LLMClientResult in
            guard let result = sendMessageResult else { throw SendError.failed }
            switch result {
            case .success(_):
                return "assistance + \(text)"
            case .failure(let failure):
                throw failure
            }
        }
        return try await task.value
    }
    
    func saveInHistory(userText: String, responseText: String) async throws {
        receivedMessages.append(.insert([userText, responseText]))
        try saveInHistoryMessageResult?.get()
    }
    
    
    func deleteFromHistory() async throws {
        receivedMessages.append(.deleteFromHistory)
        try deletionResult?.get()
    }
    
    //MARK: Help for Test porpouse
    
    func completeSendMessage(with error: Error) {
        sendMessageResult = .failure(error)
    }
    
    func completeSendMessageSuccessfully() {
        sendMessageResult = .success(())
    }
    
    func completeSaveInHistory(with error: Error) {
        saveInHistoryMessageResult = .failure(error)
    }
    
    func completeSaveInHistorySuccessfully() {
        saveInHistoryMessageResult = .success(())
    }
    
    func completeDeletion(with error: Error) {
        deletionResult = .failure(error)
    }
    
    func completeDeletionSuccessfully() {
        deletionResult = .success(())
    }
}
