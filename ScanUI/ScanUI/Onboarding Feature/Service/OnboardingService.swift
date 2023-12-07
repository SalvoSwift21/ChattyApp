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
}

public class OnboardingService: OnboardingServiceProtocol {
    
    public enum OnboardingServiceError: Swift.Error {
        case URLDataNotValid
    }
    
    public init() { }
    
    public func getLocalOnboardingCards(from url: URL) async throws -> [OnboardingViewModel] {
        
        guard let data = try? Data(contentsOf: url) else {
            throw OnboardingServiceError.URLDataNotValid
        }
        
        let root = try JSONDecoder().decode(OnboardingConfigurationModel.self, from: data)
        
        return map(from: root.onboardingCards)
    }
    
    
    fileprivate func map(from models: [OnboardingModel]) -> [OnboardingViewModel] {
        return models.map { model in
            OnboardingViewModel(image: model.image, title: model.title, subtitle: model.subtitle)
        }
    }
}
