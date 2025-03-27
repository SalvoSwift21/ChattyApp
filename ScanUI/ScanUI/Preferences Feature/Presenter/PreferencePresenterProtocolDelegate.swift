//
//  SideMenuProtocolDelegate.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation

protocol PreferencePresenterProtocol: AnyObject {
    var resourceBundle: Bundle { get set }
    var currentAppProductFeature: ProductFeature { get set }
    var menuButton: (() -> Void) { get set }
    var updatePreferences: (() -> Void) { get set }
    
    func loadData() async
    
    func saveAIPreferencereType(_ preferenceModel: PreferenceModel) async throws
    func loadAIPreferencereType() async throws -> PreferenceModel
    func loadPrivacyPolicyManager()
    
    func transactionServiceIsEnabled() -> Bool
    
    func handleErrorMessageButton(errorState: PreferenceStore.ErrorState)
}

@MainActor
public protocol PreferenceDelegate: AnyObject {
    func render(errorState: PreferenceStore.ErrorState?)
    func render(viewModel: PreferencesViewModel)
}
