//
//  ProductModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 1/23/25.
//

import StoreKit

public struct ProductFeature: Codable {
    var features: [FeatureEnum]
    var productID: String
}
