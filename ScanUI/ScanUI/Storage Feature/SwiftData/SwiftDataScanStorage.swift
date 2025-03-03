//
//  SwiftDataScanStorage.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 19/03/24.
//

import Foundation
import SwiftData
import CoreData

@MainActor
public final class SwiftDataStore {
    
    private var configuration = ModelConfiguration()
    var modelContainer: ModelContainer
    var defaultFolderName: String
    
    enum SwiftDataStore: Error {
        case modelNotFound
        case scanNotFound
        case folderNotExist
        case folderAlreadyExist
        case folderNameNotValid
        case failedToLoadPersistentContainer(Error)
    }
    
    public init(storeURL: URL, defaultFolderName: String) throws {
        do {
            self.defaultFolderName = defaultFolderName
            let schema = Schema([
                FolderStorageModel.self
            ])
            let modelConfiguration = ModelConfiguration(nil,
                                                        schema: schema,
                                                        url: storeURL,
                                                        allowsSave: true,
                                                        cloudKitDatabase: .automatic)
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            try createDefaultFolderIfNeeded()
        } catch {
            throw SwiftDataStore.failedToLoadPersistentContainer(error)
        }
    } 
    
    private func createDefaultFolderIfNeeded() throws {
        guard let folders = try self.retrieveFolders(), folders.isEmpty else {
            return
        }
        
        //Create folder
        let folder = Folder(title: defaultFolderName, scans: [], canEdit: false)
        try self.create(folder)
    }
    
    deinit { }
}
