//
//  HomeViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 11/12/23.
//

import Foundation
import UIKit

public struct Scan: Hashable {
    var id: UUID = UUID()
    
    var title: String
    var contentText: String
    var scanDate: Date
    var mainImage: UIImage?
}

public struct Folder: Hashable {
    var id: UUID = UUID()

    var title: String
    var scans: [Scan]
}

public struct HomeViewModel {
    
    var recentScans: [Scan]?
    var myFolders: [Folder] = []
    var searchResult: HomeSearchResultViewModel?
    
    public init(recentScans: [Scan]? = nil, myFolders: [Folder] = [], searchResult: HomeSearchResultViewModel? = nil) {
        self.recentScans = recentScans
        self.myFolders = myFolders
        self.searchResult = searchResult
    }
}

public struct HomeSearchResultViewModel {
    
    var scans: [Scan] = []
    var folders: [Folder] = []
    
    public init(scans: [Scan], folders: [Folder]) {
        self.scans = scans
        self.folders = folders
    }
}
