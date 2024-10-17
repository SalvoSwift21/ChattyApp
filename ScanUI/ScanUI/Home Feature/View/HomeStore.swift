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
        case error(message: String)
        case loaded(viewModel: HomeViewModel)
    }
    
    @Published var state: State = .error(message: "pippo")

    public init(state: HomeStore.State = .loading(show: true)) {
        self.state = state
    }
}


extension HomeStore: HomePresenterDelegate {
    
    public func render(errorMessage: String) {
        self.state = .error(message: errorMessage)
    }
    
    public func renderLoading(visible: Bool) {
        self.state = .loading(show: visible)
    }
    
    public func render(viewModel: HomeViewModel) {
        self.state = .loaded(viewModel: viewModel)
    }
}
