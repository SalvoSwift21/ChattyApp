//
//  PreferencesViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 22/10/24.
//

import Foundation
import LLMFeature

public struct PreferencesViewModel {
    
    var aiList: AIPreferencesList
    var selectedAI: AIPreferenceModel
    
    var translateLanguage: LLMSuppotedLanguages
    var selectedLanguage: LLMLanguage
    
    public init(aiList: AIPreferencesList, selectedAI: AIPreferenceModel, translateLanguage: LLMSuppotedLanguages, selectedLanguage: LLMLanguage) {
        self.aiList = aiList
        self.selectedAI = selectedAI
        self.translateLanguage = translateLanguage
        self.selectedLanguage = selectedLanguage
    }
}
