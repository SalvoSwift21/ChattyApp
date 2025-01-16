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
    
    public init(generativeLanguageClient: GenerativeModel) {
        self.generativeLanguageClient = generativeLanguageClient
    }

    public func sendMessage(object: GoogleFileLLMMessage) async throws -> LLMMessage? {
        
        let prompt = object.content
        let fileData = object.fileData
        
        let count = try await generativeLanguageClient.countTokens(prompt, fileData)
        
        guard count.totalTokens < 120000 else { throw GoogleAIError.generic("Document too large") }
        
        let response = try await generativeLanguageClient.generateContent(prompt, fileData)

        return try GoogleAIMapper.map(response)
    }
    
    public func saveInHistory(newObject: GoogleFileLLMMessage) async throws { }
    
    public func deleteFromHistory() async throws { }
}

public func makeGoogleGeminiAIClient(modelName: String) -> GoogleAIFileSummizeClient {
    let gl = GenerativeModel(name: modelName, apiKey: GoogleAIConfigurations.TEST_API_KEY)
    let sut = GoogleAIFileSummizeClient(generativeLanguageClient: gl)
    return sut
}
