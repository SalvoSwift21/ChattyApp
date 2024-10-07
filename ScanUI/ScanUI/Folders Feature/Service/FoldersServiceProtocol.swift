//
//  UploadFileServiceProtocol.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation

public protocol FoldersServiceProtocol: AnyObject {
    func getFolders() async -> [Folder]
    func createFolder(name: String) async throws
    
    func getStorage() -> ScanStorege
    
    func renameFolder(folder: Folder) async throws
    func deleteFolder(folder: Folder) async throws
}
