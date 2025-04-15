//
//  StoreViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 1/23/25.
//


public struct StoreViewModel {
    var products: [ProductFeature]
    var selectedProduct: ProductFeature
    
    func getOnlyPaidModels() -> [ProductFeature] {
        products.filter({ $0.productID != "free" })
    }
}
