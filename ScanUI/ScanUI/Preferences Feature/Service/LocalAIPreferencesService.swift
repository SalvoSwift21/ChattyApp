//
//  SideMenuService.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation

public class LocalAIPreferencesService: AIPreferencesServiceProtocol {

    enum LocalAIPreferencesError: Error {
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
    
    ///Use init only for preview !!!!!!!!
    public init(resourceBundle: Bundle, userDefault: UserDefaults, aiPreference: AIPreferenceModel) {
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
    
    public func saveAIPreferencereType(_ preferenceModel: PreferenceModel) async throws {
        let encodedData = try JSONEncoder().encode(preferenceModel)
        userDefault.set(encodedData, forKey: KEY_LOCAL_SERVICE_AI_TYPE_PREFERENCE)
    }
    
    public func loadAIPreferencereType() async throws -> PreferenceModel {
        do {
            guard let savedData = userDefault.data(forKey: KEY_LOCAL_SERVICE_AI_TYPE_PREFERENCE) else {
                throw LocalAIPreferencesError.AITypeNotFound
            }
            
            let decodedModel = try JSONDecoder().decode(PreferenceModel.self, from: savedData)
            return decodedModel
        } catch DecodingError.dataCorrupted(let context) {
            print("Dati corrotti: \(context.debugDescription)")
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Chiave mancante: \(key.stringValue) - \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Tipo errato: \(type) - \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Valore mancante: \(value) - \(context.debugDescription)")
        } catch {
            print("Errore sconosciuto durante la decodifica: \(error)")
        }
        throw LocalAIPreferencesError.AITypeNotFound
    }
}
