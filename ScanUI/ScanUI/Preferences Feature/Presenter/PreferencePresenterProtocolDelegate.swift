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
    
    func transactionServiceIsEnabled() -> Bool
}

public protocol PreferenceDelegate: AnyObject {
    func render(errorMessage: String)
    func render(viewModel: PreferencesViewModel)
}
