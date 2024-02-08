//
//  TextAnalyzerPresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 08/02/24.
//

import Foundation
import UIKit

public class TextAnalyzerPresenter {
        
    public var resourceBundle: Bundle

    private var service: TextAnalyzerService
    private weak var delegate: TextAnalyzerProtocolDelegate?
    
    private var scannedText: String
    private var originalSummaryText: String?
    private var modifySummaryText: String?
    
    private var textAnalyzerViewModel: TextAnalyzerViewModel

    public init(delegate: TextAnalyzerProtocolDelegate,
                service: TextAnalyzerService,
                scannedText: String,
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.scannedText = scannedText
        self.resourceBundle = bundle
        self.textAnalyzerViewModel = TextAnalyzerViewModel()
    }
    
    
    fileprivate func makeSummary() {
       
        self.showLoader(true)
        
        Task {
            do {
                let result = try await self.service.makeSummary(forText: scannedText)
                self.showLoader(false)
                self.originalSummaryText = result
                self.textAnalyzerViewModel.text = result
                self.delegate?.render(viewModel: textAnalyzerViewModel)
                self.showLoader(false)
            } catch {
                self.showLoader(false)
                self.delegate?.render(errorMessage: error.localizedDescription)
            }
        }
    }
    

    fileprivate func getScannedTextLanguage() throws -> String {
        try self.service.identificationLanguageClient.identifyLanguageProtocol(fromText: scannedText)
    }
}

extension TextAnalyzerPresenter: TextAnalyzerProtocol {
    
    public func makeTranslation() {
        print("nothing to do ")
    }
    
    public func showOriginalSummary() {
        self.textAnalyzerViewModel.text = self.originalSummaryText
        self.delegate?.render(viewModel: self.textAnalyzerViewModel)
    }
    
    public func copySummary() {
        UIPasteboard.general.string = self.textAnalyzerViewModel.text
    }
    
    public func done() {
        print("Save")
    }
    
    public func back() {
        print("Back home or scan")
    }
    
    public func updateScannedText(text: String) {
        self.modifySummaryText = text
        self.textAnalyzerViewModel.text = text
    }
}

//MARK: Help for Home
extension TextAnalyzerPresenter {
    
    fileprivate func showLoader(_ show: Bool) {
        self.delegate?.renderLoading(visible: show)
    }
}
