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
}
