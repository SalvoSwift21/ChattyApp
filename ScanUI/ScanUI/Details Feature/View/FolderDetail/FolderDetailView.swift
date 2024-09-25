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
        VStack(alignment: .center) {
            switch store.state {
            case .loading(let showLoader):
                if showLoader {
                    LoadingView()
                }
            case .error(let message):
                ErrorView(title: "Error", description: message,
                          primaryButtonTitle: "Reload view folder detail",
                          primaryAction: {
                    Task {
                        await presenter.loadData()
                    }
                }, secondaryButtonTitle: "Back", 
                          secondaryAction: {
                    presentation.wrappedValue.dismiss()
                })
            case .loaded(let viewModel):
                makeDetailView(viewModel: viewModel)
                    .navigationTitle(viewModel.folder.title)
                    .navigationBarTitleDisplayMode(.automatic)
            }
            Spacer()
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
        return ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 5, content: {
                ForEach(viewModel.folder.scans, id: \.id) { scan in
                    Button(action: {
                        self.presenter.select(scan: scan)
                        self.showScanDetail.toggle()
                    }, label: {
                        ScanItemView(resourceBundle: resourceBundle, scan: scan)
                    })
                }
            }).padding()
        }
    }
    
    @ViewBuilder
    func correctDestination() -> some View {
        if let scan = self.store.currentSelectedScan {
            NavigationStack {
                ScanDetailViewComposer.scanDetailComposedWith(scan: scan)
                    .navigationTitle(scan.title)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
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
    
    let folder = createSomeFolders().first!
    @State var scanDetailStore = FolderDetailStore(state: .loaded(viewModel: FolderDetailViewModel(folder: folder)))
                                                   
    var service = FolderDetailService(folder: folder)

    @State var presenter = FolderDetailPresenter(delegate: scanDetailStore, service: service)
   
    return NavigationView {
        FolderDetailView(store: scanDetailStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
    }
}
