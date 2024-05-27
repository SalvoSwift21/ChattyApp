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
}