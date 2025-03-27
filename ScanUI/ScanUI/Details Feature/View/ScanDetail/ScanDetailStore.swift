//
//  UploadFileStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import Foundation

public class ScanDetailStore: ObservableObject {
    
    public enum State {
        case loading(show: Bool)
        case loaded(viewModel: ScanDetailViewModel)
    }
    
    @Published var state: State = .loading(show: false)
    @Published var errorMessage: String?

    public init(state: ScanDetailStore.State = .loading(show: true)) {
        self.state = state
    }
}


extension ScanDetailStore: ScanDetailProtocolDelegate {
    
    public func render(errorMessage: String?) {
        self.errorMessage = errorMessage
    }
    
    public func renderLoading(visible: Bool) {
        self.state = .loading(show: visible)
    }
    
    public func render(viewModel: ScanDetailViewModel) {
        self.state = .loaded(viewModel: viewModel)
    }
}
