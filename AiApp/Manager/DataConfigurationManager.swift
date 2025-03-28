//
//  DataConfigurationManager.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 3/27/25.
//

import Foundation
import SwiftData
import ScanUI

public class DataConfigurationManager {
    
    static let appGroupName = "group.com.ariel.ai.scan.app"
    let defaultFolderName = String(localized: "DEFAULT_FOLDER_NAME")
    
    let changeManager: ChangeManager
    
    var storeURL: URL = {
        guard var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: DataConfigurationManager.appGroupName) else {
            return URL(string: "Test")!
        }
        let storeURLResult = storeURL.appendingPathComponent("AI.SCAN.sqlite")
        return storeURLResult
    }()
    
    var storage: ScanStorege

    init() {
        changeManager = ChangeManager()
        
        do {
            let schema = Schema([
                FolderStorageModel.self
            ])
            let modelConfiguration = ModelConfiguration(nil,
                                                        schema: schema,
                                                        allowsSave: true,
                                                        cloudKitDatabase: .automatic)
            do {
                let container: ModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
                self.storage = try SwiftDataStore(modelContainer: container, defaultFolderName: defaultFolderName, changeManager: changeManager)
            } catch {
                fatalError("Error in creation storage")
            }
        }
    }
}
