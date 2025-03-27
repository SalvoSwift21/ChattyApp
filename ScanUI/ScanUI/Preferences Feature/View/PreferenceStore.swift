//
//  SideMenuStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation

public class PreferenceStore: ObservableObject {
    
    public enum State {
        case loaded(viewModel: PreferencesViewModel)
        case unowned
    }
    
    public enum ErrorState {
        case loadPreferenceError(message: String)
        case genericError(message: String)
        
        func getMessage() -> String {
            switch self {
            case .loadPreferenceError(let message):
                message
            case .genericError(let message):
                message
            }
        }
        
        func getSubMess() -> String {
            switch self {
            case .loadPreferenceError:
                "Reload"
            case .genericError:
                "Close"
            }
        }
    }
    
    @Published var state: State
    @Published var errorState: ErrorState?

    public init(state: PreferenceStore.State = .unowned) {
        self.state = state
    }
}


extension PreferenceStore: PreferenceDelegate {
    
    public func render(errorState: ErrorState?) {
        self.errorState = errorState
    }
    
    public func render(viewModel: PreferencesViewModel) {
        self.state = .loaded(viewModel: viewModel)
    }
}
