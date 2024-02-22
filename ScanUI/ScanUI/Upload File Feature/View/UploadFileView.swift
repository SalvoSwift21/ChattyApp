//
//  UploadFileView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import SwiftUI

public struct UploadFileView: View {
    
    @State private var isImporting = false

    var presenter: UploadFilePresenter
    @ObservedObject var store: UploadFileStore

    var resourceBundle: Bundle
    
    public init(store: UploadFileStore, presenter: UploadFilePresenter, resourceBundle: Bundle = .main) {
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
                    isImporting = true
                }, secondaryButtonTitle: nil, secondaryAction: nil)
            case .loaded(let viewModel):
                VStack { }
                    .onAppear(perform: {
                        isImporting = true
                    })
                    .fileImporter(isPresented: $isImporting,
                                  allowedContentTypes: viewModel.fileTypes) {
                        let resultUrl = try? $0.get()
                        guard let url = resultUrl else { return }
                        Task {
                            try? await presenter.startScan(atURL: url)
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
        .task(presenter.loadFilesType)
    }
}

#Preview {
    @State var uploadFileStore = UploadFileStore(state: .loading(show: false))
    
    @State var presenter = UploadFilePresenter(delegate: uploadFileStore, resultOfScan: { _ in })
    
    return UploadFileView(store: uploadFileStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
}
