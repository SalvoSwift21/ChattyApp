//
//  FolderStorageModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 19/03/24.
//

import Foundation
import SwiftData

@Model
final class FolderStorageModel {
    var id: UUID = UUID()
    var creationDate = Date()
    var title: String = ""
    
    @Relationship(inverse: \ScanStorageModel.folder)
    var scans: [ScanStorageModel]?
    
    init(id: UUID = UUID(), creationDate: Date = Date(), title: String, scans: [ScanStorageModel] = []) {
        self.id = id
        self.title = title
        self.scans = scans
        self.creationDate = creationDate
    }
    
    var local: Folder {
        return Folder(id: self.id, creationDate: creationDate, title: title, scans: (scans ?? []).map({ $0.local }))
    }
}
