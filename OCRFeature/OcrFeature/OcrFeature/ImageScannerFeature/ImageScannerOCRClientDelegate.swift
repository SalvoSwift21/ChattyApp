//
//  ConcrateOCRClientDelegate.swift
//  OCRFeature
//
//  Created by Salvatore Milazzo on 22/12/23.
//

import Foundation
import UIKit

public final class ImageScannerOCRClientDelegate: OCRClientDelegate {
    
    public typealias OCRClientResponse = (String, UIImage?)
    public typealias OCRClientRecognizeItems = [String]
    
    public var recognizedItemCompletion: ((OCRClientResponse) -> Void)?
    public var errorOnScanning: ((Error) -> Void)?
    public var didRecognizeItems: ((OCRClientRecognizeItems) -> Void)?
    
    public init() { }
}
