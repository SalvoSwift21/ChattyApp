//
//  HomeServiceProtocol.swift
//  
//
//  Created by Salvatore Milazzo on 11/12/23.
//

import Foundation

public protocol HomeServiceProtocol: AnyObject {
    func getMyFolder() async throws -> [Folder]
    func getRecentScans() async throws -> [Scan]
    func getSearchResults(for query: String) async throws -> ([Folder], [Scan])

    func createFolder(name: String) async throws
    func deleteFolder(folder: Folder) async throws
    func renameFolder(folder: Folder) async throws
}
