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
            .sorted(by: { $0.scanDate < $1.scanDate })
            .prefix(5)
        
        return Array(allScan)
    }
}
