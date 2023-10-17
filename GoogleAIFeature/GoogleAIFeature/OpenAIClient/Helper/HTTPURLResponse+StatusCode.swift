//
//  HTTPURLResponse+StatusCode.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 26/07/23.
//

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
