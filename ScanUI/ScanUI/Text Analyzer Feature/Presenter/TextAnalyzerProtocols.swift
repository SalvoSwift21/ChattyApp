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
    func addTitle(_ title: String)

    func copySummary()
    
    func done()
    func back()
    
    func handleErrorPrimaryAction(state: TextAnalyzerStore.ErrorState)
    func handleErrorSecondaryAction(state: TextAnalyzerStore.ErrorState)

    func transactionFeatureIsEnabled() -> Bool
    func adMobIsEnabled() -> Bool
    
}

public protocol TextAnalyzerProtocolDelegate: AnyObject {
    func renderErrorSummary(errorMessage: String)
    func renderErrorTr(errorMessage: String)
    func renderSaveError(errorMessage: String, folder: Folder)
    func render(viewModel: TextAnalyzerViewModel)
    func goBack()
    func resetErrorState()
}
