//
//  ConcrateOCRClientDelegate.swift
//  OCRFeature
//
//  Created by Salvatore Milazzo on 22/12/23.
//

import Foundation

public final class ConcrateOCRClientDelegate: OCRClientDelegate {
    
    public typealias OCRClientResponse = String

    public var recognizedItemCompletion: ((String) -> Void)?
    public var errorOnScanning: ((Error) -> Void)?
    
    public init() { }

}
