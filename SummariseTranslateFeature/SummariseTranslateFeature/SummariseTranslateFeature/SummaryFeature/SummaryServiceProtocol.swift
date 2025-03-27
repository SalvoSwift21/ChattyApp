//
//  Summarise.swift
//  SummariseTranslateFeature
//
//  Created by Salvatore Milazzo on 05/02/24.
//

import Foundation

public protocol SummaryServiceProtocol {
    func makeSummary(fromText text: String) async throws -> String
    func makeFileSummary(fromText text: String, data: Data, mimeType: String) async throws -> String
}
