//
//  LocalAIPreferencesService.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 1/23/25.
//


import Foundation

public class LocalStoreService: StoreServiceProtocol {

    enum StoreServiceError: Error {
        case genericError
    }
    
    private var products: [ProductModel] = []
    private var resourceBundle: Bundle
    
    init(resourceBundle: Bundle, products: [ProductModel] = []) {
        self.resourceBundle = resourceBundle
        self.products = products
    }
    
    public func getProducts() -> [ProductModel] {
        return products
    }
}
