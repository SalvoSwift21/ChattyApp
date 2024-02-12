//
//  Summarise.swift
//  SummariseTranslateFeature
//
//  Created by Salvatore Milazzo on 05/02/24.
//

import Foundation

public protocol SummaryServiceProtocol {
    func makeSummary(fromText text: String) async throws -> String
}