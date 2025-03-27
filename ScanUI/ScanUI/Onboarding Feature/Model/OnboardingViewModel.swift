//
//  OnboardingModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 27/11/23.
//

import UIKit

public struct OnboardingViewModel: Identifiable, Hashable {
    
    public var id: UUID = UUID()
    
    var image: String
    var title: String
    var subtitle: String
    
    public init(id: UUID = UUID(), image: String, title: String, subtitle: String) {
        self.id = id
        self.image = image
        self.title = title
        self.subtitle = subtitle
    }
}
