//
//  UploadFileView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import SwiftUI

public struct UploadFileView: ViewModifier {
    
    @State private var isImporting = false
    @State private var isLoading = false
    
    var isPresented: Binding<Bool>
    
    var presenter: UploadFilePresenter
    @ObservedObject var store: UploadFileStore

    var resourceBundle: Bundle
    
    public init(isPresented: Binding<Bool>, store: UploadFileStore, presenter: UploadFilePresenter, resourceBundle: Bundle = .main) {
        self.store = store
        self.presenter = presenter
        self.resourceBundle = resourceBundle
        self.isPresented = isPresented
    }
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            Spacer()
            switch store.state {
            case .initState:
                content
            case .loaded(let viewModel):
                content
                    .fileImporter(isPresented: self.isPresented,
                                  allowedContentTypes: viewModel.fileTypes) {
                        let resultUrl = try? $0.get()
                        guard let url = resultUrl else { return }
                        self.isLoading.toggle()
                        Task {
                            await presenter.startScan(atURL: url)
                            self.isLoading.toggle()
                        }
                    }
                
                if self.isLoading {
                    LoadingView()
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .center
                        )
                        .background(.white)
                        .onDisappear {
                            presenter.showAdvFromViewModel()
                        }
                }
                
                if let errorState = store.errorState {
                    Color
                        .scanBackground
                        .opacity(0.15)
                        .ignoresSafeArea(.all)
                        .onTapGesture {
                            Task {
                                await self.presenter.handleCancelAction()
                            }
                        }
                    switch errorState {
                    case .error(let message):
                        ErrorView(title: "Error", description: message, primaryButtonTitle: "Try with another file", primaryAction: {
                            Task {
                                await self.presenter.handleTryAgain()
                                self.isPresented.wrappedValue = true
                            }
                        }, secondaryButtonTitle: "Cancel", secondaryAction: {
                            Task {
                                await self.presenter.handleCancelAction()
                            }
                        })
                    }
                }
                
            }
            Spacer()
        }
        .task(presenter.loadFilesType)
        .task(presenter.loadAd)
    }
}

//#Preview {
//    
//    @State var uploadFileStore = UploadFileStore(state: .loading(show: false))
//    
//    @State var presenter = UploadFilePresenter(delegate: uploadFileStore, resultOfScan: { _ in })
//    
//    return VStack { }
//        .fileImporter(store: uploadFileStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
//}

