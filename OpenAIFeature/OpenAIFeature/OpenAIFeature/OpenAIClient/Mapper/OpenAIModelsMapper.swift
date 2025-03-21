//
//  OpenAIModelsMapper.swift
//  OpenAIFeature
//
//  Created by Salvatore Milazzo on 04/09/23.
//

import Foundation

public struct OpenAIModel: Codable, Equatable {
    let id: String
    let object: String?
    let created: Int64?
    let owned_by: String
    
    public init(id: String, object: String? = nil, created: Int64? = nil, owned_by: String) {
        self.id = id
        self.object = object
        self.created = created
        self.owned_by = owned_by
    }
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

public struct OpenAITokenResponse: Codable {
    let model: String
    let tokenCount: Int
}
