//
//  PreferencesViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 22/10/24.
//

import Foundation

public struct PreferencesViewModel {
    
    var chooseAISection: AIPreferencesList
    var selectedAI: AIPreferenceModel
    
    public init(chooseAISection: AIPreferencesList, selectedAI: AIPreferenceModel) {
        self.chooseAISection = chooseAISection
        self.selectedAI = selectedAI
    }
}
