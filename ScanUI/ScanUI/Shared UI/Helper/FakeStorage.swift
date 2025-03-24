//
//  FakeStorage.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/06/24.
//

import Foundation

@MainActor
public func getFakeStorage() -> ScanStorege {
    let storeDirectory = FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask).first!

    do {
        return try SwiftDataStore(storeURL: storeDirectory, defaultFolderName: "Default", changeManager: ChangeManager())
    } catch {
        return try! SwiftDataStore(storeURL: URL(string: "Fatal ERROR")!, defaultFolderName: "Default", changeManager: ChangeManager())
    }
}
