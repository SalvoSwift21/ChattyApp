//
//  SideMenuService.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation

public class LocalAIPreferencesService: AIPreferencesServiceProtocol {
    
    
    public enum LocalAIPreferencesError: Swift.Error {
        case JSONNotFound
        case JSONNotValid
        case AITypeNotFound
    }
    
    private var resourceBundle: Bundle
    private var userDefault: UserDefaults
    
    private let KEY_LOCAL_SERVICE_AI_TYPE_PREFERENCE = "KEY_LOCAL_SERVICE_AI_TYPE_PREFERENCE"

    public init(resourceBundle: Bundle, userDefault: UserDefaults) {
        self.resourceBundle = resourceBundle
        self.userDefault = userDefault
    }
    
    public func getAIPreferences() async throws -> AIPreferencesList {
        
        guard let resourceUrl = self.resourceBundle.url(forResource: "PreferencesConfiguration", withExtension: ".json") else {
            throw LocalAIPreferencesError.JSONNotFound
        }
        
        
        guard let data = try? Data(contentsOf: resourceUrl) else {
            throw LocalAIPreferencesError.JSONNotValid
        }
        
        return try JSONDecoder().decode(AIPreferencesList.self, from: data)
    }
    
    public func saveAIPreferencereType(_ aiModel: AIPreferenceModel) async throws {
        self.userDefault.set(aiModel.aiType.rawValue, forKey: KEY_LOCAL_SERVICE_AI_TYPE_PREFERENCE)
    }
    
    public func loadAIPreferencereType() async throws -> AIPreferenceType {
        guard let result = self.userDefault.string(forKey: KEY_LOCAL_SERVICE_AI_TYPE_PREFERENCE), let preferences = AIPreferenceType(rawValue: result) else {
            throw LocalAIPreferencesError.AITypeNotFound
        }
        return preferences
    }
}
