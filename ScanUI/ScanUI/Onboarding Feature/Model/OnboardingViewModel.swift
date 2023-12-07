//
//  OnboardingModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 27/11/23.
//

import UIKit

struct OnboardingConfigurationModel: Codable {
    var onboardingCards: [OnboardingModel]
}

struct OnboardingModel: Codable {
    var image: String
    var title: String
    var subtitle: String
}

public struct OnboardingViewModel: Identifiable, Hashable {
    
    public init(id: UUID = UUID(), image: String, title: String, subtitle: String) {
        self.id = id
        self.image = image
        self.title = title
        self.subtitle = subtitle
    }
    
    public var id: UUID = UUID()
    
    var image: String
    var title: String
    var subtitle: String
}
