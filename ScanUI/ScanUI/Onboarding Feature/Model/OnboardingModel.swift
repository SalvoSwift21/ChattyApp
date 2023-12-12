//
//  OnboardingModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 11/12/23.
//

import Foundation

struct OnboardingConfigurationModel: Codable {
    var onboardingCards: [OnboardingModel]
}

struct OnboardingModel: Codable {
    var image: String
    var title: String
    var subtitle: String
}
