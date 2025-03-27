//
//  GoogleAIFeatureEndToEndTest.swift
//  GoogleAIFeatureEndToEndTest
//
//  Created by Salvatore Milazzo on 17/10/23.
//

import XCTest
import LLMFeature
import GoogleAIFeature
import GoogleGenerativeAI
import RestApi

final class GoogleAIFeatureEndToEndTest: XCTestCase {
    
    func test_endToEndTestServerGETTextSummarise_notNilResponse() async throws {
        do {
            let responseMessage = try await getSummariseText()
            debugPrint(responseMessage?.content ?? "No response")
            XCTAssertNotEqual(responseMessage, nil)
        } catch {
            XCTFail("Expected successful chat completions result, got \(error) instead")
        }
    }
    
    // MARK: - Helpers
    
    private func makeGoogleAIHTTPClient(file: StaticString = #filePath, line: UInt = #line) -> GoogleAILLMClient {
        let gl = GenerativeModel(name: "gemini-1.5-flash", apiKey: GoogleAIConfigurations.TEST_API_KEY)
        let sut = GoogleAILLMClient(generativeLanguageClient: gl, maxResourceToken: 100)
        return sut
    }

    private func getSummariseText(file: StaticString = #filePath, line: UInt = #line) async throws -> LLMMessage? {
        let client = makeGoogleAIHTTPClient()
        let exp = XCTestExpectation(description: "Wait for load completion")
        let prompt = """
                    Summarise the following text:  La Seconda Guerra Mondiale: un conflitto globale di proporzioni devastanti La Seconda    Guerra Mondiale, scoppiata nel 1939 e terminata nel 1945, è stato un conflitto di proporzioni globali che ha coinvolto la maggior parte delle nazioni del mondo. Le due principali fazioni opposte erano gli Alleati, guidati da Gran Bretagna, Francia, Stati Uniti e Unione Sovietica, e l'Asse, composto da Germania, Italia e Giappone.Le cause della Seconda Guerra Mondiale sono complesse e multifattoriali, ma alcuni dei fattori più importanti includono: L'ascesa del nazismo in Germania: Il regime nazista, guidato da Adolf Hitler, era basato su un'ideologia di estrema destra che promuoveva il nazionalismo, l'antisemitismo e l'espansionismo territoriale. Il fallimento della politica di appeasement: Le potenze europee tentarono di evitare la guerra con la Germania attraverso la politica di appeasement, concedendo a Hitler alcune delle sue richieste. Tuttavia, questa politica non fece altro che incoraggiarlo a continuare la sua aggressione.Il Patto Molotov-Ribbentrop: Un patto di non aggressione tra Germania e Unione Sovietica che includeva una segreta clausola di spartizione dell'Europa orientale.Svolgimento del conflitto: La guerra iniziò con l'invasione tedesca della Polonia nel 1939. In seguito, la Germania occupò gran parte dell'Europa occidentale e invase l'Unione Sovietica nel 1941. L'entrata in guerra degli Stati Uniti nel 1941, dopo l'attacco giapponese a Pearl Harbor, cambiò le sorti del conflitto. La guerra si concluse con la sconfitta della Germania nel 1945 e del Giappone nel 1945. Conseguenze: La Seconda Guerra Mondiale ha avuto conseguenze devastanti per il mondo intero. Si stima che il conflitto abbia causato la morte di oltre 60 milioni di persone, tra cui civili e militari. L'Europa fu devastata dai bombardamenti e dalle battaglie. La guerra portò anche alla creazione delle Nazioni Unite
                    """
        let llmMessage = GoogleFileLLMMessage(role: "user", content: prompt, fileData: nil)
        let result = try await client.sendMessage(object: llmMessage)
        exp.fulfill()
        await fulfillment(of: [exp])
        return result
    }
}

