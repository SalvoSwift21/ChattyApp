//
//  OpenAIModelsMapper.swift
//  OpenAIFeature
//
//  Created by Salvatore Milazzo on 04/09/23.
//

import Foundation

public struct OpenAIModel: Decodable {
    let id: String
    let object: String?
    let created: Int64?
    let owned_by: String
}

public final class OpenAIModelsMapper {
    private struct Root: Decodable {
        let data: [OpenAIModel]
    }
    
    public enum OpenAIModelsError: Error {
        case invalidResponseCode(String)
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [OpenAIModel] {
        guard response.isOK else {
            let errorResponse = try JSONDecoder().decode(ErrorRootResponse.self, from: data)
            throw OpenAIModelsError.invalidResponseCode("Bad Response: \(response.statusCode). \(errorResponse.error)")
        }
        
        let root = try JSONDecoder().decode(Root.self, from: data)
        
        return root.data
    }
}
