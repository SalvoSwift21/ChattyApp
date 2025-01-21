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
    public var selectedAI: AIModelType
    
    public init(selectedLanguage: LLMLanguage, selectedAI: AIModelType) {
        self.selectedLanguage = selectedLanguage
        self.selectedAI = selectedAI
    }
}
