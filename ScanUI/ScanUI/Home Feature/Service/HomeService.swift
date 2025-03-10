//
//  HomeService.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 11/12/23.
//

import Foundation
import RestApi

public class HomeService: HomeServiceProtocol {
    
    public enum HomeServiceError: Error {
        case RetriveFoldersError
        
        var localizedDescription: String {
            switch self {
            case .RetriveFoldersError:
                return "HOME_SERVICE_ERROR_RETRIEVEFOLDERERROR"
            }
        }
    }
    
    private var client: ScanStorege
    
    public init(client: ScanStorege) {
        self.client = client
    }
    
    public func getMyFolder() async throws -> [Folder] {
        guard let folders = try await client.retrieveFolders() else {
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
        try await self.client.create(newFolder)
    }
    
    public func getSearchResults(for query: String) async throws -> ([Folder], [Scan]) {
        let folders = await (try client.retrieveFolders() ?? [])
            .compactMap({ $0 })
            .filter({ folder in
                return folder.title.contains(query)
            })
        
        let scans = try await client.retrieveScans(title: query) ?? []
        
        return (folders, scans)
    }
    
    public func deleteFolder(folder: Folder) async throws {
        return try await client.deleteFolder(folder)
    }
    
    public func renameFolder(folder: Folder) async throws {
        return try await client.renameFolder(folder)
    }
    
    
}
