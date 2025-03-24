//
//  UploadFileViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation
import SwiftUI

public struct ScanDetailViewModel {
    
    var scan: Scan
    
    public init(scan: Scan) {
        self.scan = scan
    }
    
    
    func getSharableObject() -> ScanShareModel {
        return ScanShareModel(image: scan.mainImage, description: scan.contentText)
    }
}

struct ScanShareModel {
    public var image: UIImage?
    public var description: String
    
    func getAnyArray() -> [Any] {
        return [image, description].compactMap({ $0 })
    }
}

