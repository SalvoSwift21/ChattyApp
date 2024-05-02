//
//  TextAnalyzerServiceProtocol.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 08/02/24.
//

import Foundation

public protocol TextAnalyzerServiceProtocol: AnyObject {
    func makeSummary(forText text: String) async throws -> String
    func getCurrentLanguage(forText text: String) async throws -> String
    func makeTranslation(forText text: String, from: Locale, to: Locale) async throws -> String
    
    func saveCurrentScan(scan: Scan, folder: Folder?) async throws
}
