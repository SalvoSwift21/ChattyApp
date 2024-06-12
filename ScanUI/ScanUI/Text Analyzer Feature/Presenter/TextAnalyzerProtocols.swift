//
//  TextAnalyzerProtocols.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 08/02/24.
//

import Foundation

public protocol TextAnalyzerProtocol: AnyObject {
    var resourceBundle: Bundle { get set }
    
    func makeTranslation() async
    
    func copySummary()
    
    func done()
    func back()
    
}

public protocol TextAnalyzerProtocolDelegate: AnyObject {
    func render(errorMessage: String)
    func renderLoading(visible: Bool)
    func render(viewModel: TextAnalyzerViewModel)
    func goBack()
}
