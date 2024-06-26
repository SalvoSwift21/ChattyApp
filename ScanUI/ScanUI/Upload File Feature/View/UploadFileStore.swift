//
//  UploadFileStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import Foundation

public class UploadFileStore: ObservableObject {
    
    public enum State {
        case error(message: String)
        case loaded(viewModel: UploadFileViewModel)
    }
    
    @Published var state: State
    public init(state: UploadFileStore.State) {
        self.state = state
    }
}


extension UploadFileStore: UploadFileProtocolsDelegate {
    
    public func render(errorMessage: String) {
        self.state = .error(message: errorMessage)
    }
    
    public func render(viewModel: UploadFileViewModel) {
        self.state = .loaded(viewModel: viewModel)
    }
}
