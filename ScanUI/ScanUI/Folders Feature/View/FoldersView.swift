//
//  UploadFileView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import SwiftUI

public struct AllFoldersView: View {
    
    var presenter: FoldersPresenter
    @ObservedObject var store: FoldersStore

    var resourceBundle: Bundle
    @State var showFolderDetail = false
    @State private var currentFolderSelected: Folder?
   
    @State var isShowingAlert: Bool = false
    @State var newFolderName: String = ""

    @State var isShowingAlertToDeleteFolder: Bool = false
    @State var isShowingAlertToRenameFolder: Bool = false
    
    @State var selectedFolderToEdit: Folder?

    
    public init(store: FoldersStore, presenter: FoldersPresenter, resourceBundle: Bundle = .main) {
        self.store = store
        self.presenter = presenter
        self.resourceBundle = resourceBundle
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            switch store.state {
            case .loading(let showLoader):
                if showLoader {
                    LoadingView()
                }
            case .loaded(let viewModel):
                ZStack {
                    ScrollView {
                        LazyVGrid(columns: [
                            .init(spacing: 8.0),
                            .init(spacing: 8.0)
                        ]) {
                            ForEach(viewModel.folders, id: \.id) { folder in
                                Button {
                                    if let _ = presenter.didSelectFolder {
                                        presenter.didSelectFolder?(folder)
                                    } else {
                                        self.currentFolderSelected = folder
                                        self.showFolderDetail.toggle()
                                    }
                                } label: {
                                    FolderItemView(resourceBundle: resourceBundle, folder: folder)
                                        .contextMenu {
                                            if folder.canEdit {
                                                Button {
                                                    self.selectedFolderToEdit = folder
                                                    isShowingAlertToRenameFolder.toggle()
                                                } label: {
                                                    Label("Rename", systemImage: "pencil")
                                                }
                                                
                                                Button(role: .destructive) {
                                                    self.selectedFolderToEdit = folder
                                                    isShowingAlertToDeleteFolder.toggle()
                                                } label: {
                                                    Label("Delete folder", systemImage: "folder.fill.badge.minus")
                                                }
                                            }
                                        }
                                        .cornerRadius(10)
                                }
                            }
                        }.padding()
                    }
                    .textFieldAlert(text: $newFolderName,
                                    title: "Rename folder",
                                    okButtonTitle: "Ok",
                                    placeholder: "Folder Name",
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
                    .alert("Are you shure to delete this folder ?", isPresented: $isShowingAlertToDeleteFolder, actions: {
                        Button("Ok", action: {
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
                    
                    if let message = store.errorMessage {
                        Color
                            .scanBackground
                            .opacity(0.15)
                            .ignoresSafeArea(.all)
                            .onTapGesture {
                                self.presenter.handleErrorButton()
                            }
                        
                        ErrorView(title: "GENERIC_ERROR_TITLE", description: message, primaryButtonTitle: "Close", primaryAction: {
                            self.presenter.handleErrorButton()
                        }, secondaryButtonTitle: nil, secondaryAction: nil)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
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
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .background(.clear)
        .task {
            await presenter.loadData()
        }
        .navigationDestination(isPresented: $showFolderDetail, destination: {
            if let folder = self.currentFolderSelected {
                FolderDetailComposer.folderDetailComposedWith(folder: folder, client: presenter.getStorage(), currentProductFeature: presenter.currentProductFeature, bannerID: presenter.bannerID)
            } else {
                EmptyView().task {
                    showFolderDetail.toggle()
                }
            }
        })
    }
}

#Preview {
    @State var foldersStore = FoldersStore(state: .loading(show: false))
    let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    var service = FoldersLocalService(client: getFakeStorage())

    var product = ProductFeature(features: [], productID: "")
    
    @State var presenter = FoldersPresenter(delegate: foldersStore, service: service, currentProductFeature: product, bannerID: "12345678", didSelectFolder: { folder in
        print("Folders \(folder.title)")
    })
    
    return NavigationView {
        AllFoldersView(store: foldersStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
            .navigationTitle("Test folders")
    }
}
