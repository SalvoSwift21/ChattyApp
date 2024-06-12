//
//  ConcrateOCRClientDelegate.swift
//  OCRFeature
//
//  Created by Salvatore Milazzo on 22/12/23.
//

import Foundation
import UIKit

public final class ConcrateOCRClientDelegate: OCRClientDelegate {
    
    public typealias OCRClientResponse = (String, UIImage?)

    public var recognizedItemCompletion: ((OCRClientResponse) -> Void)?
    public var errorOnScanning: ((Error) -> Void)?
    
    public init() { }

}
