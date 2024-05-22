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
    
    public init(store: FoldersStore, presenter: FoldersPresenter, resourceBundle: Bundle = .main) {
        self.store = store
        self.presenter = presenter
        self.resourceBundle = resourceBundle
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            Spacer()
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
                            FolderItem(resourceBundle: resourceBundle, folder: folder)
                                .onTapGesture {
                                    presenter.didSelectFolder(folder)
                                }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .background(.clear)
        .task {
            await presenter.loadData()
        }
        .navigationTitle("All folders")
    }
}

#Preview {
    @State var foldersStore = FoldersStore(state: .loading(show: false))
    let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    let swiftDataStore = try! SwiftDataStore(storeURL: url)
    var service = FoldersLocalService(client: swiftDataStore)

    @State var presenter = FoldersPresenter(delegate: foldersStore, service: service, didSelectFolder: { folder in
        print("Folders \(folder.title)")
    })
    
    return AllFoldersView(store: foldersStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
}
