//
//  SideMenuProtocolDelegate.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation

protocol PreferencePresenterProtocol: AnyObject {
    var resourceBundle: Bundle { get set }
    var menuButton: (() -> Void) { get set }
    var updatePreferences: (() -> Void) { get set }

    func loadData() async
    
    func saveAIPreferencereType(_ aiModel: AIPreferenceModel) async throws
    func loadAIPreferencereType() async throws -> AIPreferenceType
}

public protocol PreferenceDelegate: AnyObject {
    func render(errorMessage: String)
    func render(viewModel: PreferencesViewModel)
}
