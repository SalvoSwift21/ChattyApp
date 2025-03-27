//
//  OnboardingService.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 28/11/23.
//

import Foundation
import UIKit

public protocol OnboardingServiceProtocol: AnyObject {
    func getLocalOnboardingCards(from url: URL) async throws -> [OnboardingViewModel]
    func needToShowOnboarding() async -> Bool
    func saveCompleteOnboardin()
}

public class OnboardingService: OnboardingServiceProtocol {
    
    public enum OnboardingServiceError: Swift.Error {
        case URLDataNotValid
    }
    
    private let KEY_ONBOARDING_COMPLETE = "KEY_ONBOARDING_COMPLETE"
    
    public init() { }
    
    public func getLocalOnboardingCards(from url: URL) async throws -> [OnboardingViewModel] {
        
        guard let data = try? Data(contentsOf: url) else {
            throw OnboardingServiceError.URLDataNotValid
        }
        
        let root = try JSONDecoder().decode(OnboardingConfigurationModel.self, from: data)
        
        return map(from: root.onboardingCards)
    }
    
    public func needToShowOnboarding() async -> Bool {
        return !UserDefaults.standard.bool(forKey: KEY_ONBOARDING_COMPLETE)
    }
    
    public func saveCompleteOnboardin() {
        UserDefaults.standard.set(true, forKey: KEY_ONBOARDING_COMPLETE)
    }
    
    
    fileprivate func map(from models: [OnboardingModel]) -> [OnboardingViewModel] {
        return models.map { model in
            OnboardingViewModel(image: model.image, title: model.title, subtitle: model.subtitle)
        }
    }
}
