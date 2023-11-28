//
//  OnboardingService.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 28/11/23.
//

import Foundation
import UIKit

protocol OnboardingServiceProtocol: AnyObject {
    func getOnboardingCards(from bundle: Bundle) async throws -> [OnboardingViewModel]
}

public class OnboardingService: OnboardingServiceProtocol {
    
    public init() { }
    
    func getOnboardingCards(from bundle: Bundle) async throws -> [OnboardingViewModel] {
        
        guard let url = bundle.url(forResource: "OnboardingConfiguration", withExtension: nil) else {
            throw NSError(domain: "Onboarding Feature, not load OnboardingConfiguration", code: 1)
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw NSError(domain: "Onboarding Feature, not load data from OnboardingConfiguration.json", code: 2)
        }
        
        let root = try JSONDecoder().decode(OnboardingConfigurationModel.self, from: data)
        
        return root.cards
    }
    
}
