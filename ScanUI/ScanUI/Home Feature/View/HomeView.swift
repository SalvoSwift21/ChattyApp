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
    
    @State var isShowingAlertToDeleteFolder: Bool = false
    @State var isShowingAlertToRenameFolder: Bool = false
    
    @State var selectedFolderToEdit: Folder?

    
    @State private var searchText: String = ""

    public init(store: HomeStore, presenter: HomePresenter, resourceBundle: Bundle = .main) {
        self.store = store
        self.presenter = presenter
        self.resourceBundle = resourceBundle
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .center) {
                switch store.state {
                case .loading(let showLoader):
                    if showLoader {
                        LoadingView()
                    }
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
                                                 }, folderTapped: { folder in
                                                     presenter.folderTapped(folder)
                                                 }, renameFolder: { folder in
                                                     self.selectedFolderToEdit = folder
                                                     self.isShowingAlertToRenameFolder.toggle()
                                                 }, deleteFolder: { folder in
                                                     self.selectedFolderToEdit = folder
                                                     self.isShowingAlertToDeleteFolder.toggle()
                                                 })
                                HomeMyRecentScanView(resourceBundle: resourceBundle, scans: viewModel.recentScans ?? [], scanTapped: { scan in
                                    presenter.scanTapped(scan)
                                })
                            }
                        })
                    }
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
                    .textFieldAlert(text: $newFolderName,
                                    title: "HOME_VIEW_RENAME_ALERT_TITLE",
                                    okButtonTitle: "HOME_VIEW_RENAME_ALERT_ACTION_BUTTON",
                                    message: "HOME_VIEW_RENAME_ALERT_MESSAGE",
                                    placeholder: "HOME_VIEW_RENAME_ALERT_PLACEHOLDER",
                                    isShowingAlert: $isShowingAlertToRenameFolder) {
                        Task {
                            guard var folder = self.selectedFolderToEdit else {
                                self.selectedFolderToEdit = nil
                                self.newFolderName = ""
                                return
                            }
                            folder.title = newFolderName
                            await presenter.renameFolder(folder: folder)
                            self.selectedFolderToEdit = nil
                            self.newFolderName = ""
                        }
                    }
                    .alert("HOME_VIEW_DELETE_ALERT_TITLE", isPresented: $isShowingAlertToDeleteFolder, actions: {
                        Button("GENERIC_OK_BUTTON", action: {
                            guard let folder = self.selectedFolderToEdit else {
                                selectedFolderToEdit = nil
                                return
                            }
                            Task {
                                await presenter.deleteFolder(folder: folder)
                                selectedFolderToEdit = nil
                            }
                        })
                        Button("GENERIC_CANCEL_TITLE", action: {
                            selectedFolderToEdit = nil
                            self.isShowingAlertToDeleteFolder.toggle()
                        })
                    })
                    
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
                            presenter.menuButton()
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
                                    title: "HOME_VIEW_CREATE_ALERT_TITLE",
                                    okButtonTitle: "HOME_VIEW_CREATE_ALERT_ACTION_BUTTON",
                                    message: "HOME_VIEW_CREATE_ALERT_MESSAGE",
                                    placeholder: "HOME_VIEW_CREATE_ALERT_PLACEHOLDER",
                                    isShowingAlert: $isShowingAlert) {
                        Task {
                            await presenter.createNewFolder(name: newFolderName)
                            newFolderName = ""
                        }
                    }
                }
            }
            .padding(.horizontal)
            .task {
                await presenter.loadData()
            }
            .task(id: self.searchText, priority: .high) {
                await presenter.getSearchResult(for: searchText)
            }
            
            if let errorState = store.errorState {
                Color
                    .scanBackground
                    .opacity(0.15)
                    .ignoresSafeArea(.all)
                
                ErrorView(title: "GENERIC_ERROR_TITLE", description: errorState.getMessage(), primaryButtonTitle: "GENERIC_RELOAD_ACTION", primaryAction: {
                    presenter.handleReloadButton()
                }, secondaryButtonTitle: nil, secondaryAction: nil)
            }
        }
    }
}

#Preview {
    @State var homeStore = HomeStore()
    let swiftDataStore = getFakeStorage()
    var homeService = HomeService(client: swiftDataStore)
    @State var presenter = HomePresenter(service: homeService, delegate: homeStore, uploadImage: { }, newScan: { }, sellAllButton: { }, scanTapped: { _ in }, folderTapped: { _ in }, menuButton: { })
    
    return NavigationStack {
        HomeView(store: homeStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
    }
}
