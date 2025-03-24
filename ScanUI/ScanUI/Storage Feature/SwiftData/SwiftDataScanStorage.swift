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
    internal var modelContainer: ModelContainer
    internal var changeManager: ChangeManager
    
    var defaultFolderName: String
    
    enum SwiftDataStore: Error {
        case modelNotFound
        case scanNotFound
        case folderNotExist
        case folderAlreadyExist
        case folderNameNotValid
        case failedToLoadPersistentContainer(Error)
        
        var localizedDescription: String {
            switch self {
            case .modelNotFound:
                return "DATA_STORE_ERROR_MODELNOTFOUND"
            case .scanNotFound:
                return "DATA_STORE_ERROR_SCANNOTFOUND"
            case .folderNotExist:
                return "DATA_STORE_ERROR_FOLDERNOTEXIST"
            case .folderAlreadyExist:
                return "DATA_STORE_ERROR_FOLDERALREADYEXIST"
            case .folderNameNotValid:
                return "DATA_STORE_ERROR_FOLDERNAMENOTVALID"
            case .failedToLoadPersistentContainer(let error):
                return "DATA_STORE_ERROR_FAILEDTOLOADPERSISTENTCONTAINER"
            }
        }
    }
    
    public init(storeURL: URL, defaultFolderName: String, changeManager: ChangeManager) throws {
        do {
            self.defaultFolderName = defaultFolderName
            self.changeManager = changeManager
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
