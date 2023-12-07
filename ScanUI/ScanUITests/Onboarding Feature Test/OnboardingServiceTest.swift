//
//  OnboardingServiceTest.swift
//  ScanUITests
//
//  Created by Salvatore Milazzo on 05/12/23.
//

import XCTest
import ScanUI

final class OnboardingServiceTest: XCTestCase {
    
    func test_init() {
        let sut = makeSUT()
        
        XCTAssertNotNil(sut)
    }
    
    func test_load_correctJSONWithoutError() async throws {
        let sut = makeSUT()
        let resourceUrl = try loadJson(withName: "MockCorrectOnboardingConfiguration")
        let result = try await sut.getLocalOnboardingCards(from: resourceUrl)
        XCTAssertTrue(result.count == 2)
    }
    
    func test_load_errorMapJSONData() async {
        let sut = makeSUT()
        do {
            let resourceUrl = try loadJson(withName: "MockMapErrorOnboardingConfiguration")
            let result = try await sut.getLocalOnboardingCards(from: resourceUrl)
            XCTFail("Expected failure, got \(result) instead")
        } catch {
            XCTAssertFalse(error is OnboardingService.OnboardingServiceError)
        }
    }
    
    func test_load_errorNotCorrectJSONURL() async throws {
        let sut = makeSUT()
        do {
            let notValidUrl = URL(fileURLWithPath: "None")
            let result = try await sut.getLocalOnboardingCards(from: notValidUrl)
            XCTFail("Expected failure, got \(result) instead")
        } catch {
            XCTAssert(error is OnboardingService.OnboardingServiceError)
        }
    }
    
    
    //MARK: Helper
    private func makeSUT(file: StaticString = #filePath,
                         line: UInt = #line) -> OnboardingService {
        let sut = OnboardingService()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func loadJson(withName name: String) throws -> URL {
        guard let resourceUrl = Bundle(identifier: "com.ariel.ScanUITests")?.url(forResource: name, withExtension: ".json") else {
            throw NSError(domain: "Onboarding Feature, not load OnboardingConfiguration", code: 1)
        }
        return resourceUrl
    }
}

