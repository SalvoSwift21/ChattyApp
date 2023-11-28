//
//  OnboardingProtocols.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 28/11/23.
//

import Foundation

public protocol OnboardingPresenterProtocol: AnyObject {
    @Sendable func fetchOnboardingsCard() async
    func goNext()
    func goBack()
    func completeOnboarding()
}

public protocol OnboardingPresenterDelegate: AnyObject {
    func render(errorMessage: String)
    func renderLoading()
    func render(cards: [OnboardingViewModel])
}
