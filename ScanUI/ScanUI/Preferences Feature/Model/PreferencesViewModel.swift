//
//  PreferencesViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 22/10/24.
//

import Foundation

public struct PreferencesViewModel {
    
    var chooseAISection: AIPreferencesList
    var selectedAI: AIPreferenceType
    
    public init(chooseAISection: AIPreferencesList, selectedAI: AIPreferenceType) {
        self.chooseAISection = chooseAISection
        self.selectedAI = selectedAI
    }
}
