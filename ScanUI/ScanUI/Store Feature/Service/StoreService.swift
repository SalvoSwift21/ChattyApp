//
//  f.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 1/25/25.
//


import Foundation
import StoreKit

public class StoreService: StoreServiceProtocol {
    
    enum StoreServiceError: Error {
        case genericError
    }
    
    public init() { }
    
    func loadProductsForStoreKit(ids: [String]) async throws -> [Product] {
        return try await Product.products(for: ids)
    }
    
    func purchase(_ product: Product) async throws -> Bool  {
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            // Successful purhcase
            await transaction.finish()
            return true
        case let .success(.unverified(_, error)):
            // Successful purchase but transaction/receipt can't be verified
            // Could be a jailbroken phone
            return false
        case .pending:
            // Transaction waiting on SCA (Strong Customer Authentication) or
            // approval from Ask to Buy
            return false
        case .userCancelled:
            // ^^^
            return false
        @unknown default:
            return false
        }
    }
    
    
    func getLastPurchasedProducts() async -> String? {
        // Iterate through the user's purchased products.
        for await verificationResult in Transaction.currentEntitlements {
            switch verificationResult {
            case .verified(let transaction):
                // Check the type of product for the transaction
                // and provide access to the content as appropriate.
                if transaction.isUpgraded {
                    continue
                } else {
                    if transaction.revocationDate == nil {
                        continue
                    } else {
                        return transaction.productID
                    }
                }
            case .unverified(let unverifiedTransaction, let verificationError):
                // Handle unverified transactions based on your
                // business model.
                break
            }
        }
        return nil
    }
}
