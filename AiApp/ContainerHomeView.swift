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
    @State private var isMenuShown = false

    init(storage: ScanStorege) {
        self.scanStorage = storage
    }
    
    var body: some View {
        ZStack {
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
                }, menuButton: {
                    isMenuShown.toggle()
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
                    FolderDetailComposer.folderDetailComposedWith(folder: folder, client: self.scanStorage)
                })
                .navigationDestination(for: Scan.self, destination: { scan in
                    ScanDetailViewComposer.scanDetailComposedWith(scan: scan)
                })
                .sheet(isPresented: $showDataScan) {
                    DataScannerSection(storage: scanStorage)
                }
            }
            
            if isMenuShown {
                // Contenuto del menu
                Color.gray
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        withAnimation {
                            isMenuShown = false
                        }
                    }
                List {
                    Text("Menu item 1")
                        .onTapGesture {
                            isMenuShown = false
                        }
                    Text("Menu item 2")
                    Text("Menu item 3")
                    Text("Menu item 4")
                }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 10)
                .onEnded { _ in
                    withAnimation {
                        isMenuShown.toggle()
                    }
                }
        )
        .modifier(UploadFileComposer.uploadFileModifierView(isPresented: $showUpload, scanResult: { resultOfScan in
            path.append(resultOfScan)
        }))
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
