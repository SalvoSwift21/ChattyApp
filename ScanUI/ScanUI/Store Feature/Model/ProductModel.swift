//
//  ProductModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 1/23/25.
//

import StoreKit
import SwiftUICore

public struct ProductFeature: Codable, Hashable {
    public var features: [FeatureEnum]
    public var productID: String
    
    public init(features: [FeatureEnum], productID: String) {
        self.features = features
        self.productID = productID
    }
    
    public func getMaxResourceToken() -> Int {
        if let baseFeature = features.filter({ $0 == .complexSummaryPDF128kToken }).first {
            return baseFeature.getMaxResourcToken()
        }
        
        return 10000
    }
    
    public func getLocalizedDescription() -> (title: String, description: String) {
        let title = NSLocalizedString("\(productID)_title", comment: "").replacingOccurrences(of: "\\n", with: "\n")
        let description = NSLocalizedString("\(productID)_description", comment: "").replacingOccurrences(of: "\\n", with: "\n")

        return (title, description)
    }
}
