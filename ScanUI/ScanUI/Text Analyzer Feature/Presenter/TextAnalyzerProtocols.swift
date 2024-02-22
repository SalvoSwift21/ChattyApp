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
    func showOriginalSummary()
    func showModifyText()
    
    func copySummary()
    
    func done()
    func back()
    
    func updateScannedText(text: String)
}

public protocol TextAnalyzerProtocolDelegate: AnyObject {
    func render(errorMessage: String)
    func renderLoading(visible: Bool)
    func render(viewModel: TextAnalyzerViewModel)
}
