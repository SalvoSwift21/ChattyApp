//
//  ScanStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 19/03/24.
//

import Foundation

public typealias RetriveStoredScan = (scan: Scan?, inFolder: Folder?)

public protocol ScanStorege {
    func deleteAllFolders() throws
    func deleteFolder(_ folder: Folder) throws
    
    func insert(_ scan: Scan, inFolder folder: Folder) throws
    func create(_ folder: Folder) throws
    
    func retrieveFolders() throws -> [Folder]?
    func retrieveScan(id: UUID) throws -> RetriveStoredScan
    func retrieveFolder(id: UUID) throws -> Folder?
}
