//
//  OnboardingUIComposer.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 18/12/23.
//

import Foundation
import ScanUI

public final class OnboardingUIComposer {
    private init() {}
        
     
    public static func onboardingComposedWith(
        forceOnboarding: Bool = false,
        completeOnboarding: @escaping () -> Void = {  }
    ) -> OnboardingContainerView {
        let store = OnboardingStore()
        let service = OnboardingService()
        let onboardingPresent: OnboardingPresenter = OnboardingPresenter(service: service, delegate: store, forceShowOnboarding: forceOnboarding, completeOnboardingCompletion: completeOnboarding)
        
        return OnboardingContainerView(store: store, presenter: onboardingPresent, resourceBundle: .init(identifier: "com.ariel.ScanUI") ?? .main, localizationBundle: .main)
    }
}
