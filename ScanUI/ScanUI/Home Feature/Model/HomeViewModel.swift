//
//  HomeViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 11/12/23.
//

import Foundation
import UIKit

public struct Scan {
    var id: UUID = UUID()
    
    var title: String
    var scanDate: Date
    var mainImage: UIImage?
}

public struct Folder {
    var id: UUID = UUID()

    var title: String
    var scans: [Scan]
}

public struct HomeViewModel {
    
    var recentScans: [Scan]?
    var myFolders: [Folder] = []
    
    public init(recentScans: [Scan]? = nil, myFolders: [Folder] = []) {
        self.recentScans = recentScans
        self.myFolders = myFolders
    }
}
