//
//  SideMenuStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation

public class SideMenuStore: ObservableObject {
    
    public enum State {
        case loaded(viewModel: SideMenuViewModel)
    }
    
    @Published var state: State = .loaded(viewModel: .init(sections: []))

    public init(state: SideMenuStore.State = .loaded(viewModel: .init(sections: []))) {
        self.state = state
    }
}


extension SideMenuStore: SideMenuProtocolDelegate {
    
    public func render(viewModel: SideMenuViewModel) {
        self.state = .loaded(viewModel: viewModel)
    }
}
