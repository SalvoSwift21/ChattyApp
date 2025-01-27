//
//  PurchaseManager.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 1/24/25.
//

import Foundation

public class PurchaseManager: ObservableObject, Observable {
    var currentAppProductFeature: ProductFeature

    enum PurchaseManagerError: Error {
        case noProductAvailable
    }
    
    let storeService: StoreService
    let productFeatureService: ProductFeatureService
    
    public init(storeService: StoreService, productFeatureService: ProductFeatureService) {
        self.storeService = storeService
        self.productFeatureService = productFeatureService
        self.currentAppProductFeature = .init(features: [], productID: "")
    }
    
    public func startManager() async throws {
        currentAppProductFeature = try await self.loadCurrentFeatureProduct()
    }

    fileprivate func loadCurrentFeatureProduct() async throws -> ProductFeature {
        let productsFeatures = try await productFeatureService.getProductFeatures()
        guard let first = productsFeatures.first else { throw PurchaseManagerError.noProductAvailable }
        
        guard let lastProductId = await storeService.getLastPurchasedProducts() else {
            return first
        }
        
        return productsFeatures.first(where: { $0.productID == lastProductId }) ?? first
    }
}
