//
//  HomeService.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 11/12/23.
//

import Foundation
import RestApi

public class HomeService: HomeServiceProtocol {
    
    public enum HomeServiceError: Swift.Error {
        case RetriveFoldersError
    }
    
    private var client: ScanStorege
    
    public init(client: ScanStorege) {
        self.client = client
    }
    
    public func getMyFolder() async throws -> [Folder] {
        guard let folders = try client.retrieveFolders() else {
            throw HomeServiceError.RetriveFoldersError
        }
        return folders
    }
    
    public func getRecentScans() async throws -> [Scan] {
        let allFolders = try await self.getMyFolder()
        let allScan = allFolders
            .map({ $0.scans })
            .flatMap { $0 }
            .sorted(by: { $0.scanDate > $1.scanDate })
            .prefix(5)
        
        return Array(allScan)
    }
    
    public func createFolder(name: String) async throws {
        let newFolder = Folder(title: name, scans: [])
        try self.client.create(newFolder)
    }
    
    public func getSearchResults(for query: String) async throws -> ([Folder], [Scan]) {
        let folders = (try client.retrieveFolders() ?? [])
            .compactMap({ $0 })
            .filter({ folder in
                return folder.title.contains(query)
            })
        
        let scans = try client.retrieveScans(title: query) ?? []
        
        return (folders, scans)
    }
    
    public func deleteFolder(folder: Folder) async throws {
        return try client.deleteFolder(folder)
    }
    
    public func renameFolder(folder: Folder) async throws {
        return try client.renameFolder(folder)
    }
    
    
}
