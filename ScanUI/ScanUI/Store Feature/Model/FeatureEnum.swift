//
//  FeatureEnum.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 1/23/25.
//

import Foundation

public enum FeatureEnum: String, Codable {
    case simpleSummary
    case simpleScan
    case icloudBackup
    case sharableObject
    case removeAds
    case complexSummaryPDF128kToken
    case translation
    case complexAIModel
    case complexSummary1MToken
    
    func getMaxResourcToken() -> Int {
        switch self {
        case .complexSummary1MToken:
            return 1000 * 100
        case .complexSummaryPDF128kToken:
            return 1000 * 128
        default:
            return 0
        }
    }
}
