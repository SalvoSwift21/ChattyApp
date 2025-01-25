//
//  StoreServiceProtocol.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 1/25/25.
//


import Foundation
import StoreKit

protocol StoreServiceProtocol {
    func loadProductsForStoreKit(ids: [String]) async throws -> [Product]
    func purchase(_ product: Product) async throws -> Bool
    func getLastPurchasedProducts() async -> String?
}