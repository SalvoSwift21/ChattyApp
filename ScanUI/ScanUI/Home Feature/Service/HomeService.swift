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
    
    
    public func getFoldersAndRecentScan() async throws -> ([Folder], [Scan]) {
        guard let allFolders = try await client.retrieveFolders() else {
            throw HomeServiceError.RetriveFoldersError
        }
        
        let dataFolders = allFolders.compactMap({ $0 })
        
        let allScan = dataFolders
            .compactMap({ $0.scans })
            .flatMap { $0 }
            .sorted(by: { $0.scanDate > $1.scanDate })
            .prefix(5)
            .map({ $0.toLocal(image: true) })
        
        let localFolders = allFolders
            .compactMap({ $0.toLocal(loadScans: false, scanImage: false) })
        
        return (localFolders, Array(allScan))
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
            .map({ $0.toLocal(loadScans: false, scanImage: false) })
        
        let scans = try await client.retrieveScans(title: query)?.compactMap({ $0.toLocal(image: true) }) ?? []
        
        return (folders, scans)
    }
    
    public func deleteFolder(folder: Folder) async throws {
        return try await client.deleteFolder(folder)
    }
    
    public func renameFolder(folder: Folder) async throws {
        return try await client.renameFolder(folder)
    }
    
    
}
