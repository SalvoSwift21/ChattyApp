//
//  SideMenuServiceProtocol.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation

public protocol AIPreferencesServiceProtocol: AnyObject {
    func getAIPreferences() async throws -> AIPreferencesList
    
    func saveAIPreferencereType(_ aiModel: AIPreferenceModel) async throws
    func loadAIPreferencereType() async throws -> AIPreferenceType
}

