//
//  TranslateServiceProtocol.swift
//  SummariseTranslateFeature
//
//  Created by Salvatore Milazzo on 12/06/24.
//

import Foundation

public protocol TranslateServiceProtocol {
    func translate(fromText text: String) async throws -> String
}
