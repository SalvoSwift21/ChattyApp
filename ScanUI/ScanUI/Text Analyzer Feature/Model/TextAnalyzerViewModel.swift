//
//  TextAnalyzerViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 08/02/24.
//

import Foundation
import UIKit


public struct TextAnalyzerViewModel {
    
    var topImage: UIImage?
    var text: String
    
    public init(text: String, topImage: UIImage?) {
        self.text = text
        self.topImage = topImage
    }
}
