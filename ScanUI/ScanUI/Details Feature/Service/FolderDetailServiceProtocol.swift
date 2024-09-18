//
//  FolderDetailServiceProtocol.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/06/24.
//

import Foundation

public protocol FolderDetailServiceProtocol: AnyObject {
    func getFolder() async -> Folder
}
