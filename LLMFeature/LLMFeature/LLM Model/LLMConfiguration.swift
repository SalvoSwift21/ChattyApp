//
//  LLMConfiguration.swift
//  LLMFeature
//
//  Created by Salvatore Milazzo on 05/07/23.
//

import Foundation

public struct LLMConfiguration {
    public let API_KEY: String
    public let USER_ID: String
    
    public init(API_KEY: String, USER_ID: String) {
        self.API_KEY = API_KEY
        self.USER_ID = USER_ID
    }
}
