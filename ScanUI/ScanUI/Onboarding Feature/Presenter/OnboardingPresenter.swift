//
//  OnboardingPresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 27/11/23.
//

import Foundation

public class OnboardingPresenter: OnboardingPresenterProtocol {
    
    private var service: OnboardingService
    private weak var delegate: OnboardingPresenterDelegate?
    private var onboardingCards: [OnboardingViewModel] = []
    
    public init(service: OnboardingService, delegate: OnboardingPresenterDelegate) {
        self.service = service
        self.delegate = delegate
    }
    
    @Sendable public func fetchOnboardingsCard() async {
        do {
            self.delegate?.renderLoading()
            let result = try await self.service.getOnboardingCards(from: .main)
            self.delegate?.render(cards: result)
        } catch {
            self.delegate?.render(errorMessage: error.localizedDescription)
        }
    }
    
    public func goNext() {
        
    }
    
    public func goBack() {
        
    }
    
    public func completeOnboarding() {
        
    }
    
}
