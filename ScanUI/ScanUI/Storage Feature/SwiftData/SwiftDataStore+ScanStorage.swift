//
//  SwiftDataStore+ScanStorage.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 26/03/24.
//

import Foundation
import SwiftData

extension SwiftDataStore: ScanStorege {
    
    
    public func deleteAllFolders() throws {
        self.modelContainer.deleteAllData()
    }
    
    public func deleteFolder(_ folder: Folder) throws {
        let foldersStorage = try findFoldersByID(id: folder.id)
        
        foldersStorage.forEach { model in
            modelContainer.mainContext.delete(model)
        }
        
        try modelContainer.mainContext.save()
    }
    
    public func insert(_ scan: Scan, inFolder folder: Folder) throws {
        guard let folder = try findFoldersByID(id: folder.id).first else {
            throw SwiftDataStore.folderNotExist
        }
        let storedScan = ScanStorageModel(id: scan.id, title: scan.title, contentText: scan.contentText, scanDate: scan.scanDate, mainImage: scan.mainImage?.jpegData(compressionQuality: 0.1))
        folder.scans?.insert(storedScan, at: 0)
        try modelContainer.mainContext.save()
    }
    
    public func deleteScan(id: UUID) throws {
        guard let scan = try findScanByID(id: id) else {
            throw SwiftDataStore.scanNotFound
        }

        modelContainer.mainContext.delete(scan)
        try modelContainer.mainContext.save()
    }
    
    public func create(_ folder: Folder) throws {
        guard folder.title.isEmpty == false else {
            throw SwiftDataStore.folderNameNotValid
        }
        
        guard try findFoldersByID(id: folder.id).isEmpty else {
            throw SwiftDataStore.folderAlreadyExist
        }
        
        let storeFolder = FolderStorageModel(id: folder.id, title: folder.title, scans: folder.scans.map({ ScanStorageModel(id: $0.id, title: $0.title, contentText: $0.contentText, scanDate: $0.scanDate, mainImage: $0.mainImage?.pngData())}), canEdit: folder.canEdit)
        
        modelContainer.mainContext.insert(storeFolder)
        
        try modelContainer.mainContext.save()
    }
    
    public func renameFolder(_ folder: Folder) throws {
        guard let model = try findFoldersByID(id: folder.id).first else { return }
        model.title = folder.title
        try modelContainer.mainContext.save()
    }
    
    //MARK: Search scan service
    
    public func retrieveScan(id: UUID) throws -> Scan {
        guard let result = try findScanByID(id: id) else {
            throw SwiftDataStore.scanNotFound
        }
        
        return result.toLocal(image: true)
    }
    
    public func retrieveScans(title: String) throws -> [ScanStorageModel]? {
        guard let folders = try retrieveFolders() else { throw SwiftDataStore.modelNotFound }
        
        let result = folders
            .compactMap({ $0.scans })
            .flatMap({ $0 })
            .filter({ scan in
                return scan.title.contains(title)
            })
            .sorted(by: { $0.scanDate < $1.scanDate })
        
        return result
    }
    
    //MARK: Search folders service
    public func retrieveFolders() throws -> [FolderStorageModel]? {
        try getAllFolders()
            .sorted(by: { $0.creationDate < $1.creationDate })
    }
    
    public func retrieveFolder(id: UUID) throws -> FolderStorageModel? {
        guard let folderStorage = try findFoldersByID(id: id).first else {
            throw SwiftDataStore.modelNotFound
        }
        
        return folderStorage
    }
    
    public func retrieveFolders(title: String) throws -> [FolderStorageModel]? {
        let folderStorage = try findFoldersByTitle(title: title)
        return folderStorage
    }
    
    public func getDefaultFolderName() -> String {
        self.defaultFolderName
    }
    
    //MARK: Helper
    
    private func getAllFolders() throws -> [FolderStorageModel] {
        let folderDescriptor = FetchDescriptor<FolderStorageModel>(sortBy: [SortDescriptor(\.title)])
        return try modelContainer.mainContext.fetch(folderDescriptor)
    }
    
    private func findFoldersByID(id: UUID) throws -> [FolderStorageModel] {
        let findFolder = #Predicate<FolderStorageModel> {
            $0.id == id
        }
        let descriptor = FetchDescriptor<FolderStorageModel>(predicate: findFolder)
        return try modelContainer.mainContext.fetch(descriptor)
    }
    
    private func findFoldersByTitle(title: String) throws -> [FolderStorageModel] {
        let findFolder = #Predicate<FolderStorageModel> {
            $0.title == title
        }
        let descriptor = FetchDescriptor<FolderStorageModel>(predicate: findFolder)
        return try modelContainer.mainContext.fetch(descriptor)
    }
    
    private func findScanByID(id: UUID) throws -> ScanStorageModel? {
        let findScan = #Predicate<ScanStorageModel> {
            $0.id == id
        }
        
        var descriptor = FetchDescriptor<ScanStorageModel>(predicate: findScan)
        descriptor.fetchLimit = 1
        
        guard let scan = try modelContainer.mainContext.fetch(descriptor).first else {
            throw SwiftDataStore.modelNotFound
        }
        
        return scan
    }
}
