//
//  FakeStorage.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/06/24.
//

import Foundation
import SwiftData

@MainActor
public func getFakeStorage() -> ScanStorege {
    let storeDirectory = FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask).first!
    
    do {
        let schema = Schema([
            FolderStorageModel.self
        ])
        
        let modelConfiguration = ModelConfiguration(nil,
                                                    schema: schema,
                                                    url: storeDirectory,
                                                    allowsSave: true,
                                                    cloudKitDatabase: .none)
        let container: ModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        return try SwiftDataStore(modelContainer: container, defaultFolderName: "defaultFolderName", changeManager: ChangeManager())
        
    } catch {
        fatalError()
    }
}
