//
//  OnboardingPresenterTest.swift
//  ScanUITests
//
//  Created by Salvatore Milazzo on 05/12/23.
//

import XCTest
import ScanUI

final class OnboardingPresenterTest: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT(value: (nil, nil))
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoading_displaysNoErrorMessageAndStartsLoading() async {
        let (sut, view) = makeSUT(value: (data: nil, error: nil))
        
        await sut.fetchOnboardingsCard()
        
        XCTAssert(view.messages.contains(.renderLoading))
    }
    
    func test_didFinishLoadingOnboardingViewModels_displaysResourceAndStopsLoading() async {
        let fakeOnbaordingViewModel = makeOnboardingViewModel(image: "Test", title: "title test", subtitle: "sub title test")
        let (sut, view) = makeSUT(value: ([fakeOnbaordingViewModel], nil))
        
        await sut.fetchOnboardingsCard()
        
        XCTAssertEqual(view.messages, [
            .renderLoading,
            .render(cards: [fakeOnbaordingViewModel])
        ])
    }
    
    func test_didFinishLoadingWithError_displaysLocalizedErrorMessageAndStopsLoading() async {
        let (sut, view) = makeSUT(value: (nil, anyNSError()))
        
        await sut.fetchOnboardingsCard()
        
        XCTAssertEqual(view.messages, [
            .renderLoading,
            .render(errorMessage: anyNSError().localizedDescription)
        ])
    }
    
    func test_didFinishLoading_completeOnboarding() async {
        let (sut, view) = makeSUT(value: ([], nil))
        
        await sut.fetchOnboardingsCard()
        sut.completeOnboarding()
        
        XCTAssertEqual(view.messages, [
            .renderLoading,
            .render(cards: [])
        ])
    }
    
    
    //MARK: Helper
    private func makeSUT(value: (data: [OnboardingViewModel]?, error: Error?),
                 file: StaticString = #filePath,
                 line: UInt = #line) -> (OnboardingPresenter, ViewSpy) {
        let service = OnboardingServiceSpy(data: value.data, error: value.error)
        let view = ViewSpy()
        let sut = OnboardingPresenter(service: service, delegate: view, completeOnboardingCompletion: { })
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
        
    }
    
    private class OnboardingServiceSpy: OnboardingServiceProtocol {
        
        private var data: [OnboardingViewModel]?
        private var error: Error?
        
        init(data: [OnboardingViewModel]?, error: Error?) {
            self.data = data
            self.error = error
        }
        
        func getLocalOnboardingCards(from url: URL) async throws -> [ScanUI.OnboardingViewModel] {
            guard let data = self.data else {
                throw self.error ?? NSError(domain: "Error not set", code: 999)
            }
            return data
        }
        
        func needToShowOnboarding() async -> Bool {
            true
        }
        
        func saveCompleteOnboardin() { }
    }
    
    private class ViewSpy: OnboardingPresenterDelegate {
        
        enum Message: Hashable {
            case render(errorMessage: String?)
            case renderLoading
            case render(cards: [OnboardingViewModel])
        }
        
        private(set) var messages = Set<Message>()
        
        func render(errorMessage: String) {
            messages.insert(.render(errorMessage: errorMessage))
        }
        
        func renderLoading() {
            messages.insert(.renderLoading)
        }
        
        func render(cards: [OnboardingViewModel]) {
            messages.insert(.render(cards: cards))
        }
    }
    
    private func makeOnboardingViewModel(image: String, title: String, subtitle: String) -> OnboardingViewModel {
        OnboardingViewModel(image: image, title: title, subtitle: subtitle)
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }

}
