//
//  HomeView.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 16/02/24.
//

import SwiftUI
import ScanUI

struct ContainerHomeView: View {
    
    @State private var scanStorage: ScanStorege
    
    @State private var presentedTextAnalyzer: [ScanResult] = []
    
    @State private var showUpload = false
    @State private var showScan = false
    @State private var showAllFolders = false
    @State private var showScanDetail = false
    @State private var showFolderDetail = false

    @State private var currentSelectedScan: Scan?
    @State private var currentSelectedFolder: Folder?

    init(storage: ScanStorege) {
        self.scanStorage = storage
    }
    
    var body: some View {
        NavigationStack(path: $presentedTextAnalyzer) {
            HomeUIComposer.homeComposedWith(client: scanStorage, upload: {
                showUpload.toggle()
            }, newScan: {
                showScan.toggle()
            }, scanTapped: { scan in
                self.currentSelectedScan = scan
                showScanDetail.toggle()
            }, folderTapped: { folder in
                self.currentSelectedFolder = folder
                showFolderDetail.toggle()
            }, sellAllButton: {
                showAllFolders.toggle()
            })
            .navigationDestination(isPresented: $showScan, destination: {
                DataScannerComposer.uploadFileComposedWith { resultOfScan in
                    presentedTextAnalyzer.append(resultOfScan)
                }
            })
            .navigationDestination(isPresented: $showUpload, destination: {
                UploadFileComposer.uploadFileComposedWith { resultOfScan in
                    presentedTextAnalyzer.append(resultOfScan)
                }
            })
            .navigationDestination(isPresented: $showAllFolders, destination: {
                FoldersViewComposer.foldersComposedWith(client: scanStorage)
                    .navigationTitle("All folders")
            })
            .navigationDestination(isPresented: $showScanDetail, destination: {
                if let scan = self.currentSelectedScan {
                    ScanDetailViewComposer.scanDetailComposedWith(scan: scan)
                } else {
                    EmptyView().task {
                        showScanDetail.toggle()
                    }
                }
            })
            .navigationDestination(isPresented: $showFolderDetail, destination: {
                if let folder = self.currentSelectedFolder {
                    FolderDetailComposer.folderDetailComposedWith(folder: folder)
                } else {
                    EmptyView().task {
                        showFolderDetail.toggle()
                    }
                }
            })
            .navigationDestination(for: ScanResult.self) { scanResult in
                TextAnalyzerComposer.textAnalyzerComposedWith(scanResult: scanResult, scanStorage: scanStorage)
            }
        }
    }
}

//#Preview {
//    let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
//    let swiftDataStore = try! SwiftDataStore(storeURL: url)
//    HStack {
//        ContainerHomeView(storage: swiftDataStore)
//    }
//}
