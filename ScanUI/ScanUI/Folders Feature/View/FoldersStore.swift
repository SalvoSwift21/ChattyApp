//
//  UploadFileStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import Foundation

public class FoldersStore: ObservableObject {
    
    public enum State {
        case loading(show: Bool)
        case error(message: String)
        case loaded(viewModel: FoldersViewModel)
    }
    
    @Published var state: State = .loading(show: false)

    public init(state: FoldersStore.State = .loading(show: true)) {
        self.state = state
    }
}


extension FoldersStore: FoldersProtocolDelegate {
    
    public func render(errorMessage: String) {
        self.state = .error(message: errorMessage)
    }
    
    public func renderLoading(visible: Bool) {
        self.state = .loading(show: visible)
    }
    
    public func render(viewModel: FoldersViewModel) {
        self.state = .loaded(viewModel: viewModel)
    }
}