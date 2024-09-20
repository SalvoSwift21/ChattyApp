//
//  HomeView.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 16/02/24.
//

import SwiftUI
import ScanUI


struct ContainerHomeView: View {
    
    enum HomeNavigationDestination: Hashable {
        case newScan, seeAll
    }
    
    @State private var scanStorage: ScanStorege
    
    @State private var showUpload: Bool = false
    @State private var showDataScan: Bool = false
    
    @State private var path: NavigationPath = .init()
    
    init(storage: ScanStorege) {
        self.scanStorage = storage
    }
    
    var body: some View {
        NavigationStack(path: $path.animation(.easeOut)) {
            HomeUIComposer.homeComposedWith(client: scanStorage, upload: {
                showUpload.toggle()
            }, newScan: {
                showDataScan.toggle()
            }, scanTapped: { scan in
                path.append(scan)
            }, folderTapped: { folder in
                path.append(folder)
            }, sellAllButton: {
                path.append(HomeNavigationDestination.seeAll)
            })
            .navigationDestination(for: HomeNavigationDestination.self) { destination in
                switch destination {
                case .newScan:
                    EmptyView()
                case .seeAll:
                    FoldersViewComposer.foldersComposedWith(client: scanStorage)
                        .navigationTitle("All folders")
                }
            }
            .navigationDestination(for: ScanResult.self) { scanResult in
                TextAnalyzerComposer.textAnalyzerComposedWith(scanResult: scanResult, scanStorage: scanStorage)
            }
            .navigationDestination(for: Folder.self, destination: { folder in
                FolderDetailComposer.folderDetailComposedWith(folder: folder)
            })
            .navigationDestination(for: Scan.self, destination: { scan in
                ScanDetailViewComposer.scanDetailComposedWith(scan: scan)
            })
            .fileImporter(isPresented: $showUpload) { resultOfScan in
                path.append(resultOfScan)
            }
            .sheet(isPresented: $showDataScan) {
                DataScannerSection(storage: scanStorage)
            }
        }
    }
}


struct DataScannerSection: View {
    
    @State private var pathOfScanSection: NavigationPath = .init()
    @State private var scanStorage: ScanStorege
    @Environment(\.presentationMode) var isPresented

    init(storage: ScanStorege) {
        self.scanStorage = storage
    }
    
    var body: some View {
        NavigationStack(path: $pathOfScanSection.animation(.easeOut)) {
            DataScannerComposer.uploadFileComposedWith { resultOfScan in
                pathOfScanSection.append(resultOfScan)
            }
            .navigationDestination(for: ScanResult.self) { scanResult in
                TextAnalyzerComposer.textAnalyzerComposedWith(scanResult: scanResult, scanStorage: scanStorage, done: {
                    isPresented.wrappedValue.dismiss()
                })
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
