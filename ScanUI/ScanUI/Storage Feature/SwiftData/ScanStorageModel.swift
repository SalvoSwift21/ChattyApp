//
//  ScanStorageModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 19/03/24.
//

import Foundation
import SwiftData
import UIKit


@Model 
public final class ScanStorageModel {
    public var id: UUID = UUID()
    
    var title: String = ""
    var contentText: String = ""
    var scanDate: Date = Date()

    @Attribute(.externalStorage)
    var mainImage: Data?
    
    var folder: FolderStorageModel?
    
    public init(id: UUID = UUID(), title: String, contentText: String, scanDate: Date, mainImage: Data? = nil) {
        self.id = id
        self.title = title
        self.scanDate = scanDate
        self.contentText = contentText
        self.mainImage = mainImage
    }
    
    public func toLocal(image: Bool = false) -> Scan {
        return Scan(id: id, title: title, contentText: contentText, scanDate: scanDate, mainImageData: image ? mainImage : nil)
    }
}
