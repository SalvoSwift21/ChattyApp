//
//  SwiftDataScanStorage.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 19/03/24.
//

import Foundation
import SwiftData
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
        
        try createDefaultFolderIfNeeded()
        startObservingDataChanges()
    }
    
    
    private func createDefaultFolderIfNeeded() throws {
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
                                               name: .NSManagedObjectContextObjectsDidChange,
                                               object: nil)
    }

    
    @objc private func updateFromICloud(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
//
//        if let insertedObjects = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, !insertedObjects.isEmpty {
//            for object in insertedObjects {
//                if let folder = object as? FolderStorageModel {
//                    // Ora 'folder' è un'istanza del tuo modello FolderStorageModel
//                    print("Trovata cartella: \(folder.title)")
//                    // Puoi accedere alle proprietà del tuo modello
//                } else if let scan = object as? ScanStorageModel {
//                    // Ora 'scan' è un'istanza del tuo modello ScanStorageModel
//                    print("Trovata scansione: \(scan.title)")
//                }
//            }
//        }
//
//        if let updatedObjects = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, !updatedObjects.isEmpty {
//            for object in updatedObjects {
//                if object is FolderStorageModel {
//                    print("Cartella aggiornata.")
//                    // Esegui qui la tua logica specifica per l'aggiornamento di FolderStorageModel
//                    // Ad esempio, potresti voler ricaricare l'elenco delle cartelle o aggiornare il nome visualizzato.
//                } else if object is ScanStorageModel {
//                    print("Scansione aggiornata.")
//                    // Esegui qui la tua logica specifica per l'aggiornamento di ScanStorageModel
//                    // Ad esempio, potresti voler ricaricare il contenuto della scansione.
//                }
//            }
//        }
//
//        if let deletedObjects = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, !deletedObjects.isEmpty {
//            for object in deletedObjects {
//                if object is FolderStorageModel {
//                    print("Cartella eliminata.")
//                    // Esegui qui la tua logica specifica per l'eliminazione di FolderStorageModel
//                    // Ad esempio, potresti voler rimuovere la cartella dall'elenco nella UI.
//                } else if object is ScanStorageModel {
//                    print("Scansione eliminata.")
//                    // Esegui qui la tua logica specifica per l'eliminazione di ScanStorageModel
//                    // Ad esempio, potresti voler rimuovere la scansione dalla vista.
//                }
//            }
//        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
