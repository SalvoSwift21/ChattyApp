//
//  Service.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation

public class FoldersLocalService: FoldersServiceProtocol {
        
    private var client: ScanStorege
    
    public init(client: ScanStorege) {
        self.client = client
    }
    
    public func getFolders() async -> [Folder] {
        do {
            return try await self.client.retrieveFolders()?.compactMap({ $0.toLocal() }) ?? []
        } catch {
            debugPrint("Error get folders \(error.localizedDescription)")
            return []
        }
    }
    
    
    public func createFolder(name: String) async throws {
        let newFolder = Folder(title: name, scans: [])
        try await self.client.create(newFolder)
    }
    
    public func deleteFolder(folder: Folder) async throws {
        return try await client.deleteFolder(folder)
    }
    
    public func renameFolder(folder: Folder) async throws {
        return try await client.renameFolder(folder)
    }
    
    public func getStorage() -> any ScanStorege {
        self.client
    }
}
