//
//  ProductModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 1/23/25.
//

import StoreKit

public struct ProductModel: Codable, Decodable {
    
    var features: [FeatureEnum]
    var storeKITModel: Product
    
    init(features: [FeatureEnum], storeKITModel: Product) {
        self.features = features
        self.storeKITModel = storeKITModel
    }
}
