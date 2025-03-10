//
//  TextAnalyzerStore.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 08/02/24.
//

import Foundation

public class TextAnalyzerStore: ObservableObject {
    
    public enum State {
        case showViewModel
    }
    
    public enum ErrorState {
        case errorSummary(message: String)
        case errorTR(message: String)
        case saveError(message: String, folder: Folder)
        
        func getMessage() -> String {
            switch self {
            case .errorSummary(let message):
                return message
            case .errorTR(let message):
                return message
            case .saveError(let message, _):
                return message
            }
        }
    }
    
    @Published var state: State = .showViewModel
    @Published var errorState: ErrorState? = nil
    
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
    
    public func render(viewModel: TextAnalyzerViewModel) {
        self.viewModel = viewModel
        self.state = .showViewModel
    }
    
    public func renderErrorTr(errorMessage: String) {
        self.errorState = .errorTR(message: errorMessage)
    }
    
    public func renderErrorSummary(errorMessage: String) {
        self.errorState = .errorSummary(message: errorMessage)
    }
    
    public func renderSaveError(errorMessage: String, folder: Folder) {
        self.errorState = .saveError(message: errorMessage, folder: folder)
    }
    
    public func resetErrorState() {
        self.errorState = nil
    }
}
