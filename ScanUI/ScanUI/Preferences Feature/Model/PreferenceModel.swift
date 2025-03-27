//
//  PreferenceModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/01/25.
//

import Foundation
import LLMFeature

public struct PreferenceModel: Codable {
    public var selectedLanguage: LLMLanguage
    public var selectedAI: AIPreferenceModel
    
    public init(selectedLanguage: LLMLanguage, selectedAI: AIPreferenceModel) {
        self.selectedLanguage = selectedLanguage
        self.selectedAI = selectedAI
    }
}
