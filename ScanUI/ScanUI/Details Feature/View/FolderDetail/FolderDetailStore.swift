//
//  UploadFileStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import Foundation

public class FolderDetailStore: ObservableObject {
    
    public enum State {
        case loading(show: Bool)
        case error(message: String)
        case loaded(viewModel: FolderDetailViewModel)
    }
    
    @Published var state: State = .loading(show: false)
    @Published var currentSelectedScan: Scan?

    public init(state: FolderDetailStore.State = .loading(show: true)) {
        self.state = state
    }
}


extension FolderDetailStore: FolderDetailProtocolDelegate {
    
    public func render(errorMessage: String) {
        self.state = .error(message: errorMessage)
    }
    
    public func renderLoading(visible: Bool) {
        self.state = .loading(show: visible)
    }
    
    public func render(viewModel: FolderDetailViewModel) {
        self.state = .loaded(viewModel: viewModel)
    }
    
    public func select(scan: Scan) {
        self.currentSelectedScan = scan
    }
}
