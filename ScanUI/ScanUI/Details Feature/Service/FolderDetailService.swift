//
//  FolderDetailService.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/06/24.
//

import Foundation

public class FolderDetailService: FolderDetailServiceProtocol {
    
    private var folder: Folder
    
    public init(folder: Folder) {
        self.folder = folder
    }
    
    public func getFolder() async -> Folder {
        return folder
    }
}
