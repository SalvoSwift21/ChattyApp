//
//  SwiftDataScanStorage.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 19/03/24.
//

import Foundation
import SwiftData
import SwiftUI

import CoreData


public final class SwiftDataStore {

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
    
    
    public init(modelContainer: ModelContainer,
                defaultFolderName: String,
                changeManager: ChangeManager) throws {
        self.modelContainer = modelContainer
        self.defaultFolderName = defaultFolderName
        self.changeManager = changeManager
        
        startObservingDataChanges()
    }
    
    
    public func createDefaultFolderIfNeeded() throws {
        Task {
            guard let folders = try await self.retrieveFolders(), folders.isEmpty else {
                return
            }
            
            //Create folder
            let folder = Folder(title: defaultFolderName, scans: [], canEdit: false)
            try await self.create(folder)
        }
    }
    
    
    func startObservingDataChanges() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateFromICloud(_:)),
                                               name: .NSPersistentStoreRemoteChange,
                                               object: nil)
    }

   
    @MainActor
    @objc private func updateFromICloud(_ notification: Notification) {
        debugPrint("Changes from iCloud detected.")
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
