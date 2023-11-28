//
//  OnboardingStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 28/11/23.
//

import Foundation

public class OnboardingStore: ObservableObject {
    
    public enum State {
        case loading
        case error(message: String)
        case loaded(cards: [OnboardingViewModel])
    }
    
    @Published var state: State = .loading
    
    public init(state: OnboardingStore.State = .loading) {
        self.state = state
    }
}


extension OnboardingStore: OnboardingPresenterDelegate {
    
    public func renderLoading() {
        self.state = .loading
    }
    
    public func render(errorMessage: String) {
        self.state = .error(message: errorMessage)
    }
    
    public func render(cards: [OnboardingViewModel]) {
        self.state = .loaded(cards: cards)
    }
}
