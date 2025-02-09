//
//  GoogleAIPDFSummizeClient.swift
//  GoogleAIFeature
//
//  Created by Salvatore Milazzo on 10/12/24.
//

import Foundation
import RestApi
import LLMFeature
import GoogleGenerativeAI
import PDFKit


public class GoogleAIFileSummizeClient: LLMClient {
   
    public enum GoogleAIError: Error {
        case generic(String)
        case notValidChatResult
    }
    
    public typealias LLMClientResult = LLMMessage?
    public typealias LLMClientObject = GoogleFileLLMMessage
        

    private var generativeLanguageClient: GenerativeModel
    private var MAX_RESOURCES_TOKEN = 100000
    
    public init(generativeLanguageClient: GenerativeModel, maxResourceToken: Int) {
        self.generativeLanguageClient = generativeLanguageClient
        self.MAX_RESOURCES_TOKEN = maxResourceToken
    }

    public func sendMessage(object: GoogleFileLLMMessage) async throws -> LLMMessage? {
        let response = try await handleCorrectResponse(object)
        return try GoogleAIMapper.map(response)
    }
    
    fileprivate func handleCorrectResponse(_ object: GoogleFileLLMMessage) async throws -> GenerateContentResponse {
        let prompt = object.content
        
        guard let fileData = object.fileData else {
            return try await generativeLanguageClient.generateContent(prompt)
        }
        
        let count = try await generativeLanguageClient.countTokens(prompt, fileData)
        
        guard count.totalTokens < MAX_RESOURCES_TOKEN else { throw GoogleAIError.generic("Document too large") }
        
        return try await generativeLanguageClient.generateContent(prompt, fileData)
    }
    
    public func saveInHistory(newObject: GoogleFileLLMMessage) async throws { }
    
    public func deleteFromHistory() async throws { }
}

public func makeGoogleGeminiAIClient(modelName: String, maxResourceToken: Int) -> GoogleAIFileSummizeClient {
    let gl = GenerativeModel(name: modelName, apiKey: GoogleAIConfigurations.TEST_API_KEY)
    let sut = GoogleAIFileSummizeClient(generativeLanguageClient: gl, maxResourceToken: maxResourceToken)
    return sut
}
