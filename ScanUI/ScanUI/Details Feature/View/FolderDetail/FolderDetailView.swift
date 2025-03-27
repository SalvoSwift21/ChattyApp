//
//  UploadFileView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import SwiftUI

public struct FolderDetailView: View {
    
    @Environment(\.presentationMode) var presentation
    
    var presenter: FolderDetailPresenter
    @ObservedObject var store: FolderDetailStore
    @State private var showingCopyConfirmView = false
    @State private var showScanDetail = false

    var resourceBundle: Bundle
    
    public init(store: FolderDetailStore, presenter: FolderDetailPresenter, resourceBundle: Bundle = .main) {
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
                    VStack {
                        if viewModel.folder.scans.isEmpty {
                            EmptyStateView(iconSystemName: "folder", title: "EMPTY_VIEW_NO_FOLDER_SCAN_TITLE", subtitle: "EMPTY_VIEW_NO_FOLDER_SCAN_SUB")
                                .padding(.vertical, 80)
                        } else {
                            makeDetailView(viewModel: viewModel)
                        }
                    }
                    .navigationTitle(viewModel.folder.title)
                    .navigationBarTitleDisplayMode(.inline)
                }
                Spacer()
            }
            
            
            if let errorMessage = store.errorMessage {
                Color
                    .scanBackground
                    .opacity(0.15)
                    .ignoresSafeArea(.all)
                
                ErrorView(title: "GENERIC_ERROR_TITLE", description: errorMessage,
                          primaryButtonTitle: "GENERIC_RELOAD_ACTION",
                          primaryAction: {
                    self.presenter.handlePrimaryErrorButton()
                }, secondaryButtonTitle: "GENERIC_BACK_ACTION",
                          secondaryAction: {
                    presentation.wrappedValue.dismiss()
                })
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
        .sheet(isPresented: $showScanDetail) {
            correctDestination()
        }
    }
    
    func makeDetailView(viewModel: FolderDetailViewModel) -> some View {
        return List {
            ForEach(viewModel.folder.scans, id: \.id) { scan in
                Button(action: {
                    self.presenter.select(scan: scan)
                    self.showScanDetail.toggle()
                }, label: {
                    ScanItemView(resourceBundle: resourceBundle, scan: scan, showDivider: false)
                })
            }
            .onDelete(perform: presenter.removeScanRows)
            .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 0))
            .listRowSeparator(.automatic)
        }
        .scrollContentBackground(.hidden)
        .background(.clear)
    }
    
    @ViewBuilder
    func correctDestination() -> some View {
        if let scan = self.store.currentSelectedScan {
            NavigationStack {
                ScanDetailViewComposer.scanDetailComposedWith(scan: scan, currentProductFeature: presenter.getProductInfoAndBanner().0, bannerID: presenter.getProductInfoAndBanner().1)
                    .navigationTitle(scan.title)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("GENERIC_CLOSE_ACTION") {
                                self.showScanDetail.toggle()
                            }
                        }
                    }
            }
        } else {
            EmptyView()
        }
    }
}

#Preview {
    @State var folderDetailStore = FolderDetailStore()

    let folder = createSomeFolders().first!
                                                   
    var service = FolderDetailService(folder: folder, client: getFakeStorage())
    var product = ProductFeature(features: [], productID: "")

    @State var presenter = FolderDetailPresenter(delegate: folderDetailStore, service: service, currentProductFeature: product, bannerID: "12345678")
    
    return NavigationView {
        FolderDetailView(store: folderDetailStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
    }
}
