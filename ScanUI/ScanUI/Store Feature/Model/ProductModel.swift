//
//  ProductModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 1/23/25.
//

import StoreKit

public struct ProductFeature: Codable {
    public var features: [FeatureEnum]
    public var productID: String
    
    public init(features: [FeatureEnum], productID: String) {
        self.features = features
        self.productID = productID
    }
    
    public func getMaxResourceToken() -> Int {
        if let proFeature = features.filter({ $0 == .complexSummary1MToken }).first {
            return proFeature.getMaxResourcToken()
        }
        
        if let baseFeature = features.filter({ $0 == .complexSummary1MToken }).first {
            return baseFeature.getMaxResourcToken()
        }
        
        return 0
    }
}
