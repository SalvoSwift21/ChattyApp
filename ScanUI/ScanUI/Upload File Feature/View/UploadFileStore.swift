//
//  UploadFileStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import Foundation

public class UploadFileStore: ObservableObject {
    
    public enum State {
        case initState
        case loaded(viewModel: UploadFileViewModel)
    }
    
    public enum ErrorState {
        case error(message: String)
    }
    
    @Published var errorState: ErrorState?
    @Published var state: State
    
    public init(state: UploadFileStore.State) {
        self.state = state
    }
}

@MainActor
extension UploadFileStore: UploadFileProtocolsDelegate {
    
    public func render(viewModel: UploadFileViewModel) {
        self.state = .loaded(viewModel: viewModel)
    }
    
    public func render(errorMessage: String) {
        self.errorState = .error(message: errorMessage)
    }
    
    public func renderInitState() {
        self.state = .initState
    }
    
    public func resetErrorState() {
        self.errorState = nil
    }
}
