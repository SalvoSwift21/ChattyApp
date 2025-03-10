//
//  HomeView.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 16/02/24.
//

import SwiftUI
import ScanUI


struct MainContainerView: View {

    @Environment(\.requestReview) var requestReview

    enum HomeNavigationDestination: Hashable {
        case newScan, seeAll
    }
    
    @State private var scanStorage: ScanStorege
    
    @State private var showUpload: Bool = false
    @State private var showDataScan: Bool = false
    @State private var showPremiumFeature: Bool = false

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
                HomeSection
            case .chooseAi:
                PreferencesView
            case .premium:
                StoreFeatureView
            case .rateUs: EmptyView()
            default:
                SomeSection(presentSideMenu: $isMenuShown)
            }
            SideMenuUIComposer.sideMenuStore(isMenuShown: $isMenuShown) { row in
                switch row.rowType {
                case .rateUs:
                    requestReview()
                default:
                    selectedSideMenuTab = row.rowType
                }
                isMenuShown.toggle()
            }
        }
    }
    
    var HomeSection: some View {
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
                    FoldersViewComposer.foldersComposedWith(client: scanStorage,
                                                            currentProductFeature: AppConfiguration.shared.purchaseManager.currentAppProductFeature,
                                                            bannerID: AppConfiguration.shared.adMobManager.getBannerUnitId())
                        .navigationTitle("ALL_FOLDER_TITLE")
                }
            }
            .navigationDestination(for: ScanResult.self) { scanResult in
                if let view = TextAnalyzerComposer.textAnalyzerComposedWith(scanResult: scanResult, scanStorage: scanStorage) {
                    view
                }
            }
            .navigationDestination(for: Folder.self, destination: { folder in
                FolderDetailComposer.folderDetailComposedWith(folder: folder,
                                                              client: self.scanStorage,
                                                              currentProductFeature: AppConfiguration.shared.purchaseManager.currentAppProductFeature,
                                                              bannerID: AppConfiguration.shared.adMobManager.getBannerUnitId())
            })
            .navigationDestination(for: Scan.self, destination: { scan in
                ScanDetailViewComposer.scanDetailComposedWith(scan: scan,
                                                              currentProductFeature: AppConfiguration.shared.purchaseManager.currentAppProductFeature,
                                                              bannerID: AppConfiguration.shared.adMobManager.getBannerUnitId())
            })
            .fullScreenCover(isPresented: $showDataScan) {
                DataScannerSection(storage: scanStorage)
            }
        }
        .tint(.primeAccentColor)
        .modifier(UploadFileComposer.uploadFileModifierView(isPresented: $showUpload, scanResult: { resultOfScan in
            path.append(resultOfScan)
        }))
    }
    
    var PreferencesView: some View {
        NavigationStack {
            PreferencesUIComposer.preferencesComposedWith {
                isMenuShown.toggle()
            } updatePreferences: {
                AppConfiguration.shared.updatePreferences()
            }
        }
    }
    
    var StoreFeatureView: some View {
        NavigationStack {
            StoreUIComposer.storeComposedWith {
                isMenuShown.toggle()
            }
        }
    }
}

struct SomeSection: View {
    @EnvironmentObject var manager: PurchaseManager
    @Binding var presentSideMenu: Bool

    var body: some View {
        Button {
            presentSideMenu.toggle()
        } label: {
            VStack {
                Text("Hai comprato questo pacchetto\n \(manager.currentAppProductFeature.productID)\n \(manager.currentAppProductFeature.features)")
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
            DataScannerComposer.dataScanComposedWith { resultOfScan in
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
