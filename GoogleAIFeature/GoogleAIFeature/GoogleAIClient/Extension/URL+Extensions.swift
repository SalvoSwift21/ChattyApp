//
//  URL+Extensions.swift
//  GoogleAIFeature
//
//  Created by Salvatore Milazzo on 10/12/24.
//

import Foundation
import UniformTypeIdentifiers

public extension URL {
    func mimeType() -> UTType? {
        if let mimeType = UTType(filenameExtension: self.pathExtension) {
            return mimeType
        }
        else {
            return nil
        }
    }
}
