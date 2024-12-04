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
    var canEdit: Bool = true
    
    @Relationship(inverse: \ScanStorageModel.folder)
    var scans: [ScanStorageModel]?
    
    init(id: UUID = UUID(), creationDate: Date = Date(), title: String, scans: [ScanStorageModel] = [], canEdit: Bool = true) {
        self.id = id
        self.title = title
        self.scans = scans
        self.creationDate = creationDate
        self.canEdit = canEdit
    }
    
    var local: Folder {
        return Folder(id: self.id, creationDate: creationDate, title: title, scans: (scans ?? []).map({ $0.local }), canEdit: canEdit)
    }
}
