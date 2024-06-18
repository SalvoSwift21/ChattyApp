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
            case .error(let message):
                ErrorView(title: "Error", description: message, primaryButtonTitle: "Try with another file", primaryAction: {
//                    presenter.loadData()
                }, secondaryButtonTitle: nil, secondaryAction: nil)
            case .loaded(let viewModel):
                ScrollView {
                    LazyVGrid(columns: [
                        .init(spacing: 8.0),
                        .init(spacing: 8.0)
                    ]) {
                        ForEach(viewModel.folders, id: \.id) { folder in
                            FolderItemView(resourceBundle: resourceBundle, folder: folder)
                                .onTapGesture {
                                    if let completion = presenter.didSelectFolder {
                                        presenter.didSelectFolder?(folder)
                                    } else {
                                        self.currentFolderSelected = folder
                                        self.showFolderDetail.toggle()
                                    }
                                }
                        }
                    }.padding()
                }
                .navigationBarTitleDisplayMode(.large)
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
                FolderDetailComposer.folderDetailComposedWith(folder: folder)
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

    @State var presenter = FoldersPresenter(delegate: foldersStore, service: service, didSelectFolder: { folder in
        print("Folders \(folder.title)")
    })
    
    return NavigationView {
        AllFoldersView(store: foldersStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
            .navigationTitle("Test folders")
    }
}
