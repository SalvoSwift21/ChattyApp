//
//  PreferenceStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 1/23/25.
//


import Foundation

public class StoreFeatureStore: ObservableObject {
    
    public enum State {
        case error(message: String)
        case loaded(viewModel: StoreViewModel)
        case unowned
    }
    
    @Published var state: State

    public init(state: StoreFeatureStore.State = .unowned) {
        self.state = state
    }
}


extension StoreFeatureStore: StoreDelegate {
    public func render(errorMessage: String) {
        self.state = .error(message: errorMessage)
    }
    
    
    public func render(viewModel: StoreViewModel) {
        self.state = .loaded(viewModel: viewModel)
    }
}
