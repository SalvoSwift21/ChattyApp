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
    
    @State private var showUpload: Bool = false
    @State private var path: NavigationPath = .init()
    

    init(storage: ScanStorege) {
        self.scanStorage = storage
    }
    
    var body: some View {
        NavigationStack(path: $path.animation(.easeOut)) {
            HomeUIComposer.homeComposedWith(client: scanStorage, upload: {
                showUpload.toggle()
            }, newScan: {
                path.append("NewScan")
            }, scanTapped: { scan in
                path.append(scan)
            }, folderTapped: { folder in
                path.append(folder)
            }, sellAllButton: {
                path.append("SeeAll")
            })
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "NewScan":
                    DataScannerComposer.uploadFileComposedWith { resultOfScan in
                        path.append(resultOfScan)
                    }
                case "SeeAll":
                    FoldersViewComposer.foldersComposedWith(client: scanStorage)
                        .navigationTitle("All folders")
                default:
                    EmptyView()
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
