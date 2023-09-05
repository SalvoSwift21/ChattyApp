//
//  Encorder+Extensions.swift
//  OpenAIFeature
//
//  Created by Salvatore Milazzo on 05/09/23.
//

import Foundation

extension Encodable {
    public func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
