//
//  TextAnalyzerStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 08/02/24.
//

import Foundation

public class TextAnalyzerStore: ObservableObject {
    
    public enum State {
        case loading(show: Bool)
        case error(message: String)
        case showViewModel
    }
    
    @Published var state: State = .loading(show: false)
    @Published var back: Bool = false
    @Published var viewModel = TextAnalyzerViewModel(text: "", topImage: nil)

    public init(state: TextAnalyzerStore.State = .loading(show: true)) {
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
    
    public func renderLoading(visible: Bool) {
        self.state = .loading(show: visible)
    }
    
    public func render(viewModel: TextAnalyzerViewModel) {
        self.viewModel = viewModel
        self.state = .showViewModel
    }
}
