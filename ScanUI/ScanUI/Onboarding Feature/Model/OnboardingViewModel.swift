//
//  OnboardingModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 27/11/23.
//

import UIKit

struct OnboardingConfigurationModel: Codable {
    var cards: [OnboardingViewModel]
}

struct OnboardingViewModel: Codable {
    var image: String
    var title: String
    var subtitle: String
}
