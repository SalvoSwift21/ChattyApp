//
//  AIPreferencesServiceProtocol.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 1/23/25.
//


import Foundation

public protocol ProductFeatureProtocol: AnyObject {
    func getProductFeatures() async throws -> [ProductFeature]
}
