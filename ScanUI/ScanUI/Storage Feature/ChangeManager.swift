//
//  ChangeManager.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 3/12/25.
//

import Foundation

public class ChangeManager: ObservableObject, Observable {
    
    @Published public var changes: [String] = []
    
    public init() {}
    
    @MainActor
    func addNewChange(newStrings: String) {
        self.changes.append(newStrings)
    }
}
