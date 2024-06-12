//
//  TranslateClientProtocol.swift
//  SummariseTranslateFeature
//
//  Created by Salvatore Milazzo on 12/06/24.
//

import Foundation

public protocol TranslateClientProtocol {
    func translate(fromText text: String, to: Locale) async throws -> String
}
