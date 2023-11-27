//
//  OnboardingPresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 27/11/23.
//

import Foundation

class OnboardingPresenter: OnboardingPresenterProtocol {
    
    private var service: OnboardingService
    private weak var delegate: OnboardingPresenterDelegate?
    private var onboardingCards: [OnboardingViewModel] = []
    
    init(service: OnboardingService, delegate: OnboardingPresenterDelegate) {
        self.service = service
        self.delegate = delegate
    }
    
    @Sendable func fetchOnboardingsCard() async {
        do {
            self.delegate?.renderLoading()
            let result = try await self.service.getOnboardingCards(from: .main)
            self.delegate?.render(cards: result)
        } catch {
            self.delegate?.render(errorMessage: error.localizedDescription)
        }
    }
    
    func goNext() {
        
    }
    
    func goBack() {
        
    }
    
    func completeOnboarding() {
        
    }
    
}
