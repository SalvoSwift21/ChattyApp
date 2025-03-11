//
//  HomeViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 11/12/23.
//

import Foundation
import UIKit

public struct Scan: Hashable {
    var id: UUID
    
    var title: String
    var contentText: String
    var scanDate: Date
    private var mainImageData: Data?
    
    init(id: UUID = UUID(), title: String, contentText: String, scanDate: Date, mainImageData: Data? = nil) {
        self.id = id
        self.title = title
        self.contentText = contentText
        self.scanDate = scanDate
        self.mainImageData = mainImageData
    }
    
    var mainImage: UIImage? {
        guard let data = mainImageData else { return nil }
        return UIImage(data: data)
    }
}

public struct Folder: Hashable {
    var id: UUID = UUID()
    var creationDate: Date = Date()
    
    var title: String
    
    ///For only count use alweys scancount, because sometimes scans is empty because is not used. We need only the count.
    var scans: [Scan]
    
    var scanCount: Int = 0
    
    var canEdit: Bool = true
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
