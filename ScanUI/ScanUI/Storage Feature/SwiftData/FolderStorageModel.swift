//
//  FolderStorageModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 19/03/24.
//

import Foundation
import SwiftData

@Model
public final class FolderStorageModel {
    public var id: UUID = UUID()
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
    
    var scanCount: Int {
        (scans?.count) ?? 0
    }
    
    func toLocal(loadScans: Bool = true, scanImage: Bool = false) -> Folder {
        Folder(
            id: self.id,
            creationDate: creationDate,
            title: title,
            scans: loadScans ? (scans ?? []).map({ $0.toLocal(image: scanImage) }) : [],
            scanCount: scanCount,
            canEdit: canEdit
        )
    }
}
