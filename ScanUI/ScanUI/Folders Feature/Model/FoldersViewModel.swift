//
//  UploadFileViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation

public struct FoldersViewModel {
    
    var folders: [Folder] = []
    
    public init(folders: [Folder]) {
        self.folders = folders
    }
}
