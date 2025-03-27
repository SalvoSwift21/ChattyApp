//
//  LocalAIPreferencesService.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 1/23/25.
//


import Foundation

public class ProductFeatureService: ProductFeatureProtocol {

    enum StoreServiceError: Error {
        case JSONNotFound
        case JSONNotValid
        case genericError
    }
    
    private var resourceBundle: Bundle
    
    public init(resourceBundle: Bundle) {
        self.resourceBundle = resourceBundle
    }
    
    public func getProductFeatures() async throws -> [ProductFeature] {

        guard let resourceUrl = self.resourceBundle.url(forResource: "ProductsConfigurations", withExtension: ".json") else {
            throw StoreServiceError.JSONNotFound
        }
        
        
        guard let data = try? Data(contentsOf: resourceUrl) else {
            throw StoreServiceError.JSONNotValid
        }
        
        return try JSONDecoder().decode([ProductFeature].self, from: data)
    }
}
