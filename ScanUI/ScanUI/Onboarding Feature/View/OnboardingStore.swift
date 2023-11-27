//
//  OnboardingStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 28/11/23.
//

import Foundation

class OnboardingStore: ObservableObject {
    enum State {
        case loading
        case error(message: String)
        case loaded(cards: [OnboardingViewModel])
    }
    
    @Published var state: State = .loading
}


extension OnboardingStore: OnboardingPresenterDelegate {
    
    func renderLoading() {
        self.state = .loading
    }
    
    func render(errorMessage: String) {
        self.state = .error(message: errorMessage)
    }
    
    func render(cards: [OnboardingViewModel]) {
        self.state = .loaded(cards: cards)
    }
}
