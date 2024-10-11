//
//  OnboardingPresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 27/11/23.
//

import Foundation
import Combine

public class OnboardingPresenter: OnboardingPresenterProtocol {
        
    public var resourceBundle: Bundle
    
    private var service: OnboardingServiceProtocol
    private weak var delegate: OnboardingPresenterDelegate?
    private var completeOnboardingCompletion: (() -> Void)

    public init(service: OnboardingServiceProtocol, delegate: OnboardingPresenterDelegate, completeOnboardingCompletion: @escaping (() -> Void), bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.completeOnboardingCompletion = completeOnboardingCompletion
        self.resourceBundle = bundle
    }
    
    @MainActor
    @Sendable public func fetchOnboardingsCard() async {
        guard await service.needToShowOnboarding() else {
            completeOnboarding()
            return
        }
        
        do {
            self.delegate?.renderLoading()
            
            guard let resourceUrl = self.resourceBundle.url(forResource: "OnboardingConfiguration", withExtension: ".json") else {
                throw NSError(domain: "Onboarding Feature, not load OnboardingConfiguration", code: 1)
            }
            
            let result = try await self.service.getLocalOnboardingCards(from: resourceUrl)
            self.delegate?.render(cards: result)
        } catch {
            self.delegate?.render(errorMessage: error.localizedDescription)
        }
    }
    
    public func completeOnboarding() {
        self.service.saveCompleteOnboardin()
        self.completeOnboardingCompletion()
    }
}
