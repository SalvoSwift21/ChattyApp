//
//  SummaryClientProtocol.swift
//  SummariseTranslateFeature
//
//  Created by Salvatore Milazzo on 08/02/24.
//

import Foundation


public protocol SummaryClientProtocol {
    func makeSummary(fromText text: String) async throws -> String
    func makeSummary(forData data: Data, mimeType: String) async throws -> String
}
