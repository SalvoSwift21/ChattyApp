//
//  Summarise.swift
//  SummariseTranslateFeature
//
//  Created by Salvatore Milazzo on 05/02/24.
//

import Foundation
import LLMFeature

public protocol SummariseProtocol {
    func summurize(fromText text: String) async throws -> String
}
