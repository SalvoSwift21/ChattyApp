//
//  SideMenuStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation

public class PreferenceStore: ObservableObject {
    
    public enum State {
        case error(message: String)
        case loaded(viewModel: PreferencesViewModel)
        case unowned
    }
    
    @Published var state: State

    public init(state: PreferenceStore.State = .unowned) {
        self.state = state
    }
}


extension PreferenceStore: PreferenceDelegate {
    public func render(errorMessage: String) {
        self.state = .error(message: errorMessage)
    }
    
    
    public func render(viewModel: PreferencesViewModel) {
        self.state = .loaded(viewModel: viewModel)
    }
}
