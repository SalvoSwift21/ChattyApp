//
//  ConcreteDtaScannerOCRClientDelegate.swift
//  OCRFeature
//
//  Created by Salvatore Milazzo on 06/11/24.
//

import Foundation
import UIKit
import VisionKit

public final class DataScannerOCRClientDelegate: OCRClientDelegate {
    
    public typealias OCRClientResponse = (String, UIImage?)
    public typealias OCRClientRecognizeItems = [RecognizedItem]
    
    public var recognizedItemCompletion: ((OCRClientResponse) -> Void)?
    public var errorOnScanning: ((Error) -> Void)?
    public var didRecognizeItems: ((OCRClientRecognizeItems) -> Void)?

    public init() { }
}
