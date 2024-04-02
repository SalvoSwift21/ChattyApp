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
    var title: String
    
    @Relationship(deleteRule: .cascade, inverse: \ScanStorageModel.id)
    var scans: [ScanStorageModel]
    
    init(id: UUID, title: String, scans: [ScanStorageModel]) {
        self.id = id
        self.title = title
        self.scans = scans
    }
    
    var local: Folder {
        return Folder(id: self.id, title: title, scans: scans.map({ $0.local }))
    }
}
