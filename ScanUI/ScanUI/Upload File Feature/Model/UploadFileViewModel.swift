//
//  UploadFileViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation
import UniformTypeIdentifiers

public struct UploadFileViewModel {
    
    var fileTypes: [UTType] = []
    
    public init(fileTypes: [UTType] = []) {
        self.fileTypes = fileTypes
    }
}
