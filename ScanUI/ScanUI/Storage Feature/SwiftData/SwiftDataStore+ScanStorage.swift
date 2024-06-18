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
        let storedScan = ScanStorageModel(id: scan.id, title: scan.title, contentText: scan.contentText, scanDate: scan.scanDate, mainImage: scan.mainImage?.pngData())
        folder.scans?.insert(storedScan, at: 0)
        try modelContainer.mainContext.save()
    }
    
    public func create(_ folder: Folder) throws {
        guard try findFoldersByID(id: folder.id).isEmpty else {
            throw SwiftDataStore.folderAlreadyExist
        }
        
        let storeFolder = FolderStorageModel(id: folder.id, title: folder.title, scans: folder.scans.map({ ScanStorageModel(id: $0.id, title: $0.title, contentText: $0.contentText, scanDate: $0.scanDate, mainImage: $0.mainImage?.pngData())}))
        
        modelContainer.mainContext.insert(storeFolder)
        
        try modelContainer.mainContext.save()
    }
    
    public func retrieveFolders() throws -> [Folder]? {
        try getAllFolders().map({ $0.local })
    }
    
    public func retrieveScan(id: UUID) throws -> RetriveStoredScan {
        let result = try findScanByID(id: id)
        
        guard result.0 != nil else {
            throw SwiftDataStore.modelNotFound
        }
        
        return (result.0?.local, result.1?.local)
    }
    
    public func retrieveFolder(id: UUID) throws -> Folder? {
        guard let folderStorage = try findFoldersByID(id: id).first else {
            throw SwiftDataStore.modelNotFound
        }
        return folderStorage.local
    }
    
    public func retrieveFolder(title: String) throws -> Folder? {
        guard let folderStorage = try findFoldersByTitle(title: title).first else {
            throw SwiftDataStore.modelNotFound
        }
        return folderStorage.local
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
    
    private func findScanByID(id: UUID) throws -> (ScanStorageModel?, FolderStorageModel?) {
        let findFolder = #Predicate<FolderStorageModel> {
            $0.scans?.contains(where: { model in
                return model.id == id }) ?? false
        }
        var descriptor = FetchDescriptor<FolderStorageModel>(predicate: findFolder)
        descriptor.fetchLimit = 1
        descriptor.propertiesToFetch = [\.scans]
        
        guard let folder = try modelContainer.mainContext.fetch(descriptor).first else {
            throw SwiftDataStore.folderNotExist
        }
        
        let scan = folder.scans?.first(where: { model in model.id == id })
        return (scan, folder)
    }
}
