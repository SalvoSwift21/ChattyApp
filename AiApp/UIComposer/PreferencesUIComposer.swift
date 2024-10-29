//
//  PreferencesUIComposer.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 24/10/24.
//

import Foundation
import ScanUI
import SwiftUI

public final class PreferencesUIComposer {
    
    private init() {}
    
    static var preferenceStore: PreferenceStore?
    
    public static func preferencesComposedWith(
        menuButtonTapped: @escaping () -> Void = { },
        updatePreferences: @escaping () -> Void = { }
    ) -> PreferencesView {
        
        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        let preferenceStore = PreferenceStore()
        let preferenceAIService = LocalAIPreferencesService(resourceBundle: bundle, userDefault: AppConfiguration.shared.preferencesStoreManager ?? .standard)
        
        if PreferencesUIComposer.preferenceStore == nil {
            PreferencesUIComposer.preferenceStore = preferenceStore
        }
        
        let preferencePresenter = PreferencePresenter(delegate: PreferencesUIComposer.preferenceStore ?? preferenceStore, service: preferenceAIService, menuButton: menuButtonTapped, updatePreferences: updatePreferences, bundle: bundle)
                
        return PreferencesView(store:  PreferencesUIComposer.preferenceStore ?? preferenceStore, presenter: preferencePresenter, resourceBundle: bundle)
    }
}
