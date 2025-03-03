//
//  FolderDetailService.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/06/24.
//

import Foundation

public class FolderDetailService: FolderDetailServiceProtocol {
    
    private var folder: Folder
    private var client: ScanStorege
   
    public init(folder: Folder, client: ScanStorege) {
        self.folder = folder
        self.client = client
    }
    
    public func getFolder() async throws -> Folder {
        guard let folder = try await self.client.retrieveFolder(id: self.folder.id) else {
            return self.folder
        }
        
        return folder
    }
    
    public func deleteScan(scan: Scan) async throws {
        try await self.client.deleteScan(id: scan.id)
    }
}
