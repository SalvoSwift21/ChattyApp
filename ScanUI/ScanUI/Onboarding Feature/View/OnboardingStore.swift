//
//  OnboardingStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 28/11/23.
//

import Foundation
import Combine
import UIKit
import SwiftUI


public class OnboardingStore: ObservableObject {
    
    public enum State {
        case loading
        case error(message: String)
        case loaded(cards: [OnboardingViewModel])
    }
    
    @Published var state: State
    @Published var showCompleteOnboarding: Bool = false

    var totalPages = 0
    @Published var currentPage: Int {
        didSet {
            showCompleteOnboarding = totalPages-1 == currentPage
        }
    }

    
    public init(state: OnboardingStore.State = .loading) {
        self.state = state
        self._currentPage = .init(wrappedValue: 0)
    }
    
    func goNext() {
        guard totalPages - 1 > currentPage else { return }
        currentPage += 1
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
        self.totalPages = cards.count
        self.state = .loaded(cards: cards)
    }
}
