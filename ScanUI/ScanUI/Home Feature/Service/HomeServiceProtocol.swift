//
//  HomeServiceProtocol.swift
//  
//
//  Created by Salvatore Milazzo on 11/12/23.
//

import Foundation

public protocol HomeServiceProtocol: AnyObject {
    func searchFiles(from queary: String) async throws -> [Scan]
    func getMyFolder() async throws -> [Folder]
    func getRecentScans() async throws -> [Scan]
}
