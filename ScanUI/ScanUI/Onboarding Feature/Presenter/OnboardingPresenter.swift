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

    public init(service: OnboardingServiceProtocol, delegate: OnboardingPresenterDelegate, bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.resourceBundle = bundle
    }
    
    @Sendable public func fetchOnboardingsCard() async {
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
    
    public func completeOnboarding() { }
    
}
