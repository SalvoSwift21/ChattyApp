//
//  PreferencesUIComposer 2.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 1/27/25.
//

import Foundation
import ScanUI
import SwiftUI

public final class StoreUIComposer {
    
    private init() {}
    
    static var storeFeatureStore: StoreFeatureStore?
    
    public static func storeComposedWith(
        menuButtonTapped: @escaping () -> Void = { }
    ) -> StoreFeatureView {
        
        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        let storeFeatureStore = StoreFeatureStore()
        let productFeatureService = ProductFeatureService(resourceBundle: bundle)
        
        if StoreUIComposer.storeFeatureStore == nil {
            StoreUIComposer.storeFeatureStore = storeFeatureStore
        }
        
        let current = AppConfiguration.shared.purchaseManager.currentAppProductFeature
        
        let preferencePresenter = StorePresenter(delegate: StoreUIComposer.storeFeatureStore ?? storeFeatureStore,
                                                 service: productFeatureService,
                                                 productFeature: current,
                                                 bundle: bundle,
                                                 menuButton: menuButtonTapped) { newProduct in
            Task {
                await AppConfiguration.shared.purchaseManager.saveNewPurchase(newProduct)
            }
        }
                
        return StoreFeatureView(store: StoreUIComposer.storeFeatureStore ?? storeFeatureStore, presenter: preferencePresenter, resourceBundle: bundle)
    }
}
