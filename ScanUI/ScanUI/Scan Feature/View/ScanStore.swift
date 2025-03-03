//
//  ScanStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import Foundation

public class ScanStore: ObservableObject {
    
    public enum State {
        case loading(show: Bool)
        case loaded(viewModel: ScanViewModel)
    }
    
    
    @Published var errorMessage: String? = nil
    
    @Published var state: State = .loading(show: false)
    @Published var scanButtonEnabled: Bool = false
    @Published var back: Bool = false
    
    public init(state: ScanStore.State = .loading(show: true)) {
        self.state = state
    }
}


extension ScanStore: ScanProtocolsDelegate {
    
    public func goBack() {
        back.toggle()
    }
    
    public func render(errorMessage: String?) {
        self.errorMessage = errorMessage
    }
    
    public func renderLoading(visible: Bool) {
        self.state = .loading(show: visible)
    }
    
    public func render(viewModel: ScanViewModel) {
        self.state = .loaded(viewModel: viewModel)
    }
}

extension ScanStore: ScanButtonProtocolDelegate {
    
    public func enabledButton(_ enabeld: Bool) {
        self.scanButtonEnabled = enabeld
    }
}
