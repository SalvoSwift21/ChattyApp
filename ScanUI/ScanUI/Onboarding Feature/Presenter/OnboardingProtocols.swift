//
//  OnboardingProtocols.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 28/11/23.
//

import Foundation

public protocol OnboardingPresenterProtocol: AnyObject {
    var resourceBundle: Bundle { get set }
    func completeOnboarding()
    
    @Sendable func fetchOnboardingsCard() async
}

public protocol OnboardingPresenterDelegate: AnyObject {
    func render(errorMessage: String)
    func renderLoading()
    func render(cards: [OnboardingViewModel])
}
