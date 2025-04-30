//
//  GoogleAIFileSummurizeEndToEndTest.swift
//  GoogleAIFeature
//
//  Created by Salvatore Milazzo on 10/12/24.
//

import XCTest
import LLMFeature
import GoogleAIFeature
import GoogleGenerativeAI
import RestApi
import UniformTypeIdentifiers

final class GoogleAIFileSummurizeEndToEndTest: XCTestCase {
    
    private var fileURL: URL? = nil
    
    override func setUp() async throws {
        guard let pdfURL = Bundle(for: GoogleAIFileSummurizeEndToEndTest.self).url(forResource: "10-page-sample", withExtension: "pdf") else {
            XCTFail("Could not find test PDF")
            return
        }
        self.fileURL = pdfURL
    }
    
    func test_endToEndTestServerGETPDFSummarise_notNilResponse() async throws {
        guard let PDFURL = self.fileURL else {
            XCTFail("Could not find test PDF")
            return
        }
        
        do {
            let responseMessage = try await getSummariseText(pdfURL: PDFURL, maxToken: 3000)
            debugPrint(responseMessage?.content ?? "No response")
            XCTAssertNotEqual(responseMessage, nil)
        } catch {
            XCTFail("Expected successful chat completions result, got \(error) instead")
        }
    }
    
    func test_endToEndTestServerGETPDFSummarise_documentToLargeResponse() async throws {
        guard let PDFURL = self.fileURL else {
            XCTFail("Could not find test PDF")
            return
        }
        
        do {
            let responseMessage = try await getSummariseText(pdfURL: PDFURL, maxToken: 2)
            debugPrint(responseMessage?.content ?? "No response")
            XCTFail("Expected Eroor chat completions result, got \(String(describing: responseMessage?.content)) instead")
        } catch {
            XCTAssertEqual(error.localizedDescription, GoogleAILLMClient.GoogleAIError.generic("GENERIC_ERROR_DOCUMENT_TO_LARGE_NOT SUPPORTED").localizedDescription)
        }
    }
    
    // MARK: - Helpers
    
    private func makeGoogleAIHTTPClient(file: StaticString = #filePath, line: UInt = #line, maxToken: Int) -> GoogleAILLMClient {
        let gl = GenerativeModel(name: "gemini-1.5-flash", apiKey: GoogleAIConfigurations.API_KEY)
        let sut = GoogleAILLMClient(generativeLanguageClient: gl, maxResourceToken: maxToken)
        return sut
    }

    private func getSummariseText(file: StaticString = #filePath, line: UInt = #line, pdfURL: URL, maxToken: Int) async throws -> LLMMessage? {
        let client = makeGoogleAIHTTPClient(file: file, line: line, maxToken: maxToken)
        let exp = XCTestExpectation(description: "Wait for load completion")
        let prompt = """
                    Summarise the following document
                    """
        let pdfData = try Data(contentsOf: pdfURL)
        let fileData = DataGenAiThrowingPartsRepresentable(data: pdfData, preferredMIMEType: UTType.pdf.preferredMIMEType ?? "")
        let llmMessage = GoogleFileLLMMessage(role: "user", content: prompt, fileData: fileData)
        let result = try await client.sendMessage(object: llmMessage)
        exp.fulfill()
        await fulfillment(of: [exp])
        return result
    }
}
