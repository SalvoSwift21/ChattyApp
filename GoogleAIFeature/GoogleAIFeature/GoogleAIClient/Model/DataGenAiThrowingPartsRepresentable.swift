//
//  Data+Extensions.swift
//  GoogleAIFeature
//
//  Created by Salvatore Milazzo on 17/12/24.
//


import GoogleGenerativeAI
import UniformTypeIdentifiers

public class DataGenAiThrowingPartsRepresentable: ThrowingPartsRepresentable, Codable {
    
    public var data: Data
    public var preferredMIMEType: String
    
    public init(data: Data, preferredMIMEType: String) {
        self.data = data
        self.preferredMIMEType = preferredMIMEType
    }
    
    public func tryPartsValue() throws -> [ModelContent.Part] {
        return [.data(mimetype: preferredMIMEType, data)]
    }
}

extension DataGenAiThrowingPartsRepresentable: Equatable {
    public static func == (lhs: DataGenAiThrowingPartsRepresentable, rhs: DataGenAiThrowingPartsRepresentable) -> Bool {
        return lhs.data == rhs.data && lhs.preferredMIMEType == rhs.preferredMIMEType
    }
}
