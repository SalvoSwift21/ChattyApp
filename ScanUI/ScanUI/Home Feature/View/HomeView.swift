//
//  HomeView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 12/12/23.
//

import SwiftUI
import RestApi

public struct HomeView: View {
    var presenter: HomePresenter
    @ObservedObject var store: HomeStore

    var resourceBundle: Bundle
    @State var isShowingAlert: Bool = false
    @State var newFolderName: String = ""
    
    @State private var searchText: String = ""

    public init(store: HomeStore, presenter: HomePresenter, resourceBundle: Bundle = .main) {
        self.store = store
        self.presenter = presenter
        self.resourceBundle = resourceBundle
    }
    
    public var body: some View {
        ZStack {
//            Color.mainBackground.ignoresSafeArea()
            VStack(alignment: .center) {
                switch store.state {
                case .loading(let showLoader):
                    if showLoader {
                        LoadingView()
                    }
                case .error(let message):
                    ErrorView(title: "Error", description: message, primaryButtonTitle: "Reload home", primaryAction: {
                        
                    }, secondaryButtonTitle: nil, secondaryAction: nil)
                case .loaded(let viewModel):
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 32, content: {
                            if let searchResult = viewModel.searchResult {
                                HomeSearchResultView(resourceBundle: resourceBundle, 
                                                     folders: searchResult.folders, 
                                                     scans: searchResult.scans) { scan in
                                    presenter.scanTapped(scan)
                                } folderTapped: { folder in
                                    presenter.folderTapped(folder)
                                }
                            } else {
                                HomeMyFoldesView(resourceBundle: resourceBundle,
                                                 folders: viewModel.myFolders,
                                                 viewAllButtonTapped: {
                                                    presenter.sellAllButton()
                                                 },
                                                 folderTapped: { folder in
                                                    presenter.folderTapped(folder)
                                                 })
                                HomeMyRecentScanView(resourceBundle: resourceBundle, scans: viewModel.recentScans ?? [], scanTapped: { scan in
                                    presenter.scanTapped(scan)
                                })
                            }
                        })
                    }
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
                }
                
                Spacer()
                
                HStack(spacing: 28) {
                    CircleAnimationView(centerImage: UIImage(named: "gallery_icon", in: resourceBundle, compatibleWith: nil) ?? UIImage(), frame: .init(width: 64, height: 64))
                        .onTapGesture {
                            presenter.uploadImage()
                        }
                    
                    CircleAnimationView(centerImage: UIImage(named: "scan_icon", in: resourceBundle, compatibleWith: nil) ?? UIImage(), frame: .init(width: 110, height: 110))
                        .onTapGesture {
                            presenter.newScan()
                        }.padding([.trailing], 100)
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Button {
                            
                        } label: {
                            Image("menu_icon", bundle: resourceBundle)
                        }
                        
                        Image("main_logo", bundle: resourceBundle)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 50, alignment: .leading)
                        Spacer()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingAlert.toggle()
                    } label: {
                        Image("add_folder_icon", bundle: resourceBundle)
                            .foregroundColor(Color.prime)
                    }
                    .textFieldAlert(text: $newFolderName,
                                    title: "Create new Folder",
                                    okButtonTitle: "Ok",
                                    placeholder: "Folder Name",
                                    isShowingAlert: $isShowingAlert) {
                        Task {
                            await presenter.createNewFolderAndReload(name: newFolderName)
                            newFolderName = ""
                        }
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .task {
                await presenter.loadData()
            }
            .task(id: self.searchText, priority: .high) {
                await presenter.getSearchResult(for: searchText)
            }
        }
    }
}

#Preview {
    @State var homeStore = HomeStore()
    let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    let swiftDataStore = getFakeStorage()
    var homeService = HomeService(client: swiftDataStore)
    @State var presenter = HomePresenter(service: homeService, delegate: homeStore, uploadImage: { }, newScan: { }, sellAllButton: { }, scanTapped: { _ in }, folderTapped: { _ in })
    
    return NavigationStack {
        HomeView(store: homeStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
    }
}
