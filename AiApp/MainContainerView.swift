//
//  HomeView.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 16/02/24.
//

import SwiftUI
import ScanUI


struct MainContainerView: View {
    
    enum HomeNavigationDestination: Hashable {
        case newScan, seeAll
    }
    
    @State private var scanStorage: ScanStorege
    
    @State private var showUpload: Bool = false
    @State private var showDataScan: Bool = false
    
    @State private var path: NavigationPath = .init()
    
    @State private var isMenuShown = false
    @State var selectedSideMenuTab = SideMenuRowType.home

    init(storage: ScanStorege) {
        self.scanStorage = storage
    }
    
    var body: some View {
        ZStack{
            switch $selectedSideMenuTab.wrappedValue {
            case .home:
                homeSection
            default: 
                SomeSection(presentSideMenu: $isMenuShown)
            }
            
            SideMenuUIComposer.sideMenuStore(isMenuShown: $isMenuShown) { row in
                selectedSideMenuTab = row.rowType
                isMenuShown.toggle()
            }
        }
    }
    
    var homeSection: some View {
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
        .modifier(UploadFileComposer.uploadFileModifierView(isPresented: $showUpload, scanResult: { resultOfScan in
            path.append(resultOfScan)
        }))
    }
}

struct SomeSection: View {
    
    @Binding var presentSideMenu: Bool

    var body: some View {
        Button {
            presentSideMenu.toggle()
        } label: {
            Text("Hello world")
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
