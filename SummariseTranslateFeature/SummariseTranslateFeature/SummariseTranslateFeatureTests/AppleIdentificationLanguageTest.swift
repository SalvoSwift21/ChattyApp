//
//  AppleIdentificationLanguageTest.swift
//  SummariseTranslateFeatureTests
//
//  Created by Salvatore Milazzo on 07/02/24.
//

import XCTest
import SummariseTranslateFeature

final class AppleIdentificationLanguageEndToEndTest: XCTestCase {

   
    func test_successRecognizeLanguageIT() throws {
        let resultExpted = "it"
        
        let sut = makeSUT()
        let testString = "Ciao, sono una string di lingua italiana"
        let resultIdentification = try sut.identifyLanguageProtocol(fromText: testString)
        XCTAssertEqual(resultIdentification, resultExpted)
    }
    
    func test_successRecognizeLanguageEN() throws {
        let resultExpted = "en"
        
        let sut = makeSUT()
        let testString = "Hi, it is cold"
        let resultIdentification = try sut.identifyLanguageProtocol(fromText: testString)
        XCTAssertEqual(resultIdentification, resultExpted)
    }

    //MARK: Help func
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> AppleIdentificationLanguage {
        let sut = AppleIdentificationLanguage()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

}
