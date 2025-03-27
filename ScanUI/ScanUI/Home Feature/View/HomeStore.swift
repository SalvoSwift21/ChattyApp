//
//  HomeStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 12/12/23.
//

import Foundation
import SwiftUI

public class HomeStore: ObservableObject {
    
    public enum State {
        case loading(show: Bool)
        case loaded(viewModel: HomeViewModel)
    }
    
    public enum ErrorState {
        case genericError(message: String)
        
        func getMessage() -> String {
            switch self {
            case .genericError(message: let message):
                return message
            }
        }
    }
    
    @Published var state: State = .loading(show: true)
    @Published var errorState: ErrorState?

    public init(state: HomeStore.State = .loading(show: true)) {
        self.state = state
    }
}


extension HomeStore: HomePresenterDelegate {
    
    public func render(errorMessage: String?) {
        if let errorMessage {
            self.errorState = .genericError(message: errorMessage)
        } else {
            self.errorState = nil
        }
    }
    
    public func renderLoading(visible: Bool) {
        self.state = .loading(show: visible)
    }
    
    public func render(viewModel: HomeViewModel) {
        self.state = .loaded(viewModel: viewModel)
    }
}
