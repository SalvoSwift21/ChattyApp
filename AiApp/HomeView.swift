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
    
    @State private var currentSelectedScan: Scan?

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
                FoldersViewComposer.foldersComposedWith(client: scanStorage) { folderTapped in
                    print("Print \(folderTapped)")
                }.navigationTitle("All folders")
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
