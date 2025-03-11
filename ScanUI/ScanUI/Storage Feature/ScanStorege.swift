//
//  ScanStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 19/03/24.
//

import Foundation

@MainActor
public protocol ScanStorege {
    func create(_ folder: Folder) throws

    func insert(_ scan: Scan, inFolder folder: Folder) throws
    
    func retrieveFolders() throws -> [FolderStorageModel]?
    func retrieveFolder(id: UUID) throws -> FolderStorageModel?
    func retrieveFolders(title: String) throws -> [FolderStorageModel]?

    func renameFolder(_ folder: Folder) throws

    func deleteAllFolders() throws
    func deleteFolder(_ folder: Folder) throws
    
    func retrieveScan(id: UUID) throws -> Scan
    func retrieveScans(title: String) throws -> [ScanStorageModel]?
    
    func deleteScan(id: UUID) throws
    
    func getDefaultFolderName() -> String

}
