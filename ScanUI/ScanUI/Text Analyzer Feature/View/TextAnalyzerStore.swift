//
//  TextAnalyzerStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 08/02/24.
//

import Foundation

public class TextAnalyzerStore: ObservableObject {
    
    public enum State {
        case error(message: String)
        case showViewModel
    }
    
    @Published var state: State = .showViewModel
    @Published var back: Bool = false
    @Published var viewModel = TextAnalyzerViewModel(chatHistory: [])

    public init(state: TextAnalyzerStore.State = .showViewModel) {
        self.state = state
    }
}


extension TextAnalyzerStore: TextAnalyzerProtocolDelegate {
    public func goBack() {
        self.back = true
    }
    
    public func render(errorMessage: String) {
        self.state = .error(message: errorMessage)
    }
    
    public func render(viewModel: TextAnalyzerViewModel) {
        self.viewModel = viewModel
        self.state = .showViewModel
    }
}
