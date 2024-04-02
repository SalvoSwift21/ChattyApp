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
final class ScanStorageModel {
    var id: UUID
    
    var title: String
    var scanDate: Date

    @Attribute(.externalStorage)
    var mainImage: Data?
    
    init(id: UUID, title: String, scanDate: Date, mainImage: Data? = nil) {
        self.id = id
        self.title = title
        self.scanDate = scanDate
        self.mainImage = mainImage
    }
    
    var local: Scan {
        return Scan(id: id, title: title, scanDate: scanDate, mainImage: UIImage(data: mainImage ?? Data()))
    }
}