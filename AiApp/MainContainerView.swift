//
//  HomeView.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 16/02/24.
//

import SwiftUI
import ScanUI
import UserMessagingPlatform

struct MainContainerView: View {

    @Environment(\.requestReview) var requestReview

    enum HomeNavigationDestination: Hashable {
        case newScan, seeAll
    }
    
    @State private var scanStorage: ScanStorege
    
    @State private var showUpload: Bool = false
    @State private var showDataScan: Bool = false
    @State private var showPremiumFeature: Bool = false
    @State private var showOnboarding: Bool = false
    @State private var showTermsAndConditions: Bool = false
    @State private var showPrivacyPolicy: Bool = false
    @State private var showStoreView: Bool = false

    @State private var path: NavigationPath = .init()
    
    @State private var isMenuShown = false
    @State var selectedSideMenuTab = SideMenuRowType.home

    init(storage: ScanStorege) {
        self.scanStorage = storage
    }
    
    var body: some View {
        ZStack {
            switch $selectedSideMenuTab.wrappedValue {
            case .home:
                HomeSection
            case .chooseAi:
                PreferencesView
            case .premium:
                StoreFeatureView
            case .rateUs: EmptyView()
            default:
                EmptyView()
            }
            SideMenuUIComposer.sideMenuStore(isMenuShown: $isMenuShown) { row in
                switch row.rowType {
                case .rateUs:
                    requestReview()
                case .help:
                    showOnboarding.toggle()
                case .termsAndConditions:
                    showTermsAndConditions.toggle()
                case .privacyPolicy:
                    showPrivacyPolicy.toggle()
                case .premium:
                    showStoreView.toggle()
                default:
                    selectedSideMenuTab = row.rowType
                }
                isMenuShown.toggle()
            }
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingUIComposer.onboardingComposedWith(forceOnboarding: true) {
                showOnboarding.toggle()
            }
        }
        .sheet(isPresented: $showTermsAndConditions) {
            TermsAndConditionsView
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            PrivacyPolicyView
        }
        .sheet(isPresented: $showStoreView) {
            StoreUIComposer.storeComposedWith {
                showStoreView.toggle()
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
                if let view = TextAnalyzerComposer.textAnalyzerComposedWith(scanResult: scanResult, scanStorage: scanStorage, storeViewButtonTapped: {
                    showStoreView.toggle()
                }) {
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
        .fullScreenCover(isPresented: $showUpload) {
            EmptyView()
                .background(TransparentBackground())
                .modifier(UploadFileComposer.uploadFileModifierView(isPresented: $showUpload, scanResult: { resultOfScan in
                    path.append(resultOfScan)
                }))

        }
        .task {
            try? (AppConfiguration.shared.dataConfigurationManager.storage as! SwiftDataStore).createDefaultFolderIfNeeded()
        }
    }
    
    var PreferencesView: some View {
        NavigationStack {
            PreferencesUIComposer.preferencesComposedWith {
                isMenuShown.toggle()
            } updatePreferences: {
                AppConfiguration.shared.updatePreferences()
            } privacyButtonTapped: {
                Task {
                    try? await AppConfiguration.shared.userMessageManager.presentPrivacyOptionsForm()
                }
            } storeViewButtonTapped: {
                showStoreView.toggle()
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
    
    var TermsAndConditionsView: some View {
        NavigationStack {
            WebViewUIComposer.webViewComposedWith(url: Links.termsAndConditions.url)
                .navigationBarTitle("TERMS_AND_CONDIITIONS_TITLE")
        }
    }
    
    var PrivacyPolicyView: some View {
        NavigationStack {
            WebViewUIComposer.webViewComposedWith(url: Links.privacyPolicy.url)
                .navigationBarTitle("PRIVACY_POLICY_TITLE")
        }
    }
}

struct DataScannerSection: View {
    
    @State private var pathOfScanSection: NavigationPath = .init()
    @State private var scanStorage: ScanStorege
    @Environment(\.presentationMode) var isPresented
    @State private var showStoreView: Bool = false

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
                }) {
                    showStoreView.toggle()
                }
                .sheet(isPresented: $showStoreView) {
                    StoreUIComposer.storeComposedWith {
                        showStoreView.toggle()
                    }
                }
            }
        }
    }
}

struct TransparentBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
