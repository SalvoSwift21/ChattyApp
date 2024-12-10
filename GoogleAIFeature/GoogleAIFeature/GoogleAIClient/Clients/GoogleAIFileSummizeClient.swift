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
    
    public typealias LLMClientResult = GoogleFileLLMMessage?
    public typealias LLMClientObject = GoogleFileLLMMessage
        

    private var generativeLanguageClient: GenerativeModel
    
    public init(generativeLanguageClient: GenerativeModel) {
        self.generativeLanguageClient = generativeLanguageClient
    }

    public func sendMessage(object: GoogleFileLLMMessage) async throws -> GoogleFileLLMMessage? {
        
        let prompt = object.content
        guard let fileMineType = object.fileURL.mimeType() else { throw GoogleAIError.generic("Could not get file mime type") }
        switch fileMineType {
        case .pdf:
            guard let pdfDocument = PDFDocument(url: object.fileURL) else { throw GoogleAIError.generic("Unsupported file type") }
            
            let count = try await generativeLanguageClient.countTokens(prompt, pdfDocument)
            
            guard count.totalTokens > 1000000 else { throw GoogleAIError.generic("Document too large") }
            
            let response = try await generativeLanguageClient.generateContent(prompt, pdfDocument)

            return try GoogleAIMapper.map(response)
            
        default : throw GoogleAIError.generic("Unsupported file type")
        }
    }
    
    public func saveInHistory(newObject: GoogleFileLLMMessage) async throws { }
    
    public func deleteFromHistory() async throws { }
}

public func makeGoogleGeminiAIClient(modelName: String) -> GoogleAIFileSummizeClient {
    let gl = GenerativeModel(name: modelName, apiKey: GoogleAIConfigurations.TEST_API_KEY)
    let sut = GoogleAIFileSummizeClient(generativeLanguageClient: gl)
    return sut
}
