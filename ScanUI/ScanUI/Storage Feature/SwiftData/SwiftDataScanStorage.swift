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
    
    enum SwiftDataStore: Error {
        case modelNotFound
        case folderNotExist
        case folderAlreadyExist
        case failedToLoadPersistentContainer(Error)
    }
    
    public init(storeURL: URL) throws {
        do {
            let schema = Schema([
                FolderStorageModel.self
            ])
            let modelConfiguration = ModelConfiguration(nil,
                                                        schema: schema,
                                                        url: storeURL,
                                                        allowsSave: true,
                                                        cloudKitDatabase: .automatic)
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            throw SwiftDataStore.failedToLoadPersistentContainer(error)
        }
    } 
    
    deinit { }
}
